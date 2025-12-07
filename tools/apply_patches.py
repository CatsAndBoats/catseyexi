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
                check=True
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

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Apply patches sequentially from the CatseyeXI cpp-patches folder.")
    parser.add_argument("-d", "--debug", action="store_true", help="Apply patches one at a time and prompt before continuing.")
    args = parser.parse_args()

    apply_patches(debug=args.debug)
