import os
import subprocess
import argparse

# Paths
dbtool_dir_path = os.path.normpath(os.path.realpath(os.path.dirname(__file__)))
patch_dir = "../modules/catseyexi/cpp-patches"

def from_dbtool_path(path):
    return os.path.normpath(os.path.join(dbtool_dir_path, path))

def from_server_path(path):
    return os.path.normpath(os.path.join(server_dir_path, path))

def apply_patches(debug=False):
    for filename in sorted(os.listdir(patch_dir)):
        if not filename.endswith(".patch"):
            continue

        patch_path = os.path.abspath(os.path.join(patch_dir, filename))
        try:
            subprocess.run(
                ["git", "apply", "--ignore-whitespace", "-v", patch_path],
                cwd="../",
                check=True,
                capture_output=True,
                text=True
            )
            print(f"SUCCESS: Applied patch: {filename}")
        except subprocess.CalledProcessError as e:
            print(f"ERROR applying patch {filename}: {e}")
        except Exception as e:
            print(f"ERROR: Unknown applying patch {filename}: {e}")

        if debug:
            response = input("Press Enter to continue to the next patch (or type 'q' to quit): ").strip().lower()
            if response == "q":
                print("Aborted by user.")
                break

def dry_run():
    """Apply all patches sequentially with temp commits, report all failures.
    Resets to the original state when done."""
    server_dir = os.path.normpath(os.path.join(dbtool_dir_path, ".."))
    patches = sorted(f for f in os.listdir(patch_dir) if f.endswith(".patch"))

    if not patches:
        print("No patches found.")
        return

    # Save current HEAD
    result = subprocess.run(["git", "rev-parse", "HEAD"], capture_output=True, text=True, cwd=server_dir)
    original_head = result.stdout.strip()

    # Check for dirty working tree
    result = subprocess.run(["git", "status", "--porcelain"], capture_output=True, text=True, cwd=server_dir)
    if result.stdout.strip():
        print("ERROR: Working tree is dirty. Commit or stash changes before running --dry-run.")
        return

    print(f"Dry-run: testing {len(patches)} patches sequentially...\n")

    passed = []
    failed = []

    for filename in patches:
        patch_path = os.path.abspath(os.path.join(patch_dir, filename))

        # Check if patch applies
        check = subprocess.run(
            ["git", "apply", "--check", "--ignore-whitespace", patch_path],
            capture_output=True, text=True, cwd=server_dir
        )

        if check.returncode != 0:
            # Get details about why it failed
            detail = subprocess.run(
                ["git", "apply", "--verbose", "--ignore-whitespace", patch_path],
                capture_output=True, text=True, cwd=server_dir
            )
            error_lines = [l for l in detail.stderr.splitlines() if "error:" in l]
            failed.append((filename, error_lines))
            print(f"  FAIL: {filename}")
            for line in error_lines[:3]:
                print(f"        {line}")
            # Skip this patch but keep going — apply what we can to test the rest
            continue

        # Apply and temp commit so subsequent patches can build on it
        subprocess.run(
            ["git", "apply", "--ignore-whitespace", patch_path],
            cwd=server_dir, capture_output=True
        )
        subprocess.run(
            ["git", "add", "-A"], cwd=server_dir, capture_output=True
        )
        subprocess.run(
            ["git", "commit", "-m", f"temp: {filename}", "--no-verify", "-q"],
            cwd=server_dir, capture_output=True
        )
        passed.append(filename)
        print(f"  OK:   {filename}")

    # Reset back to original state
    subprocess.run(["git", "reset", "--hard", original_head], cwd=server_dir, capture_output=True)
    # Clean up any untracked files left by patches (e.g. new files)
    subprocess.run(["git", "clean", "-fd", "scripts/", "src/"], cwd=server_dir, capture_output=True)

    # Summary
    print(f"\n{'='*60}")
    print(f"RESULTS: {len(passed)} passed, {len(failed)} failed out of {len(patches)} patches")
    print(f"{'='*60}")

    if failed:
        print(f"\nFailed patches:")
        for filename, errors in failed:
            print(f"\n  {filename}:")
            for line in errors[:5]:
                print(f"    {line}")

    print(f"\nWorking tree reset to {original_head[:10]}.")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Apply patches sequentially from the CatseyeXI cpp-patches folder.")
    parser.add_argument("-d", "--debug", action="store_true", help="Apply patches one at a time and prompt before continuing.")
    parser.add_argument("--dry-run", action="store_true", help="Test all patches sequentially without keeping changes. Reports all failures at once.")
    args = parser.parse_args()

    if args.dry_run:
        dry_run()
    else:
        apply_patches(debug=args.debug)
