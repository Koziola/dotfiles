import os
import pathlib

NVIM_DIR = os.path.join(os.path.expanduser("~"), ".config/nvim")
NVIM = "nvim"

def create_dir_if_not_exists(d):
    if not os.path.exists(d):
        print(f"creating dir: {d}")
        os.makedirs(d)

def symlink_if_not_exists(src, dst):
    if not os.path.exists(dst):
        os.symlink(src, dst)
        print(f"{src} -> {dst}")
    
def resolve_destination(src_root, dest_root, name):
    src_path = pathlib.Path(src_root, name)
    idx = src_path.parts.index(NVIM)
    dest_path = pathlib.Path(dest_root).joinpath(*src_path.parts[idx+1:])
    return dest_path

def install_directory(directory, dst_root):
    for root, dirs, files in os.walk(directory):
        for d in dirs:
            dst = resolve_destination(root, dst_root, d)
            create_dir_if_not_exists(dst)
        for f in files:
            src = os.path.join(root, f)
            dst = resolve_destination(root, dst_root, f)
            symlink_if_not_exists(src, dst)
    
def main():
    create_dir_if_not_exists(NVIM_DIR)

    current_dir = pathlib.Path(__file__).parent.resolve()
    nvim_dotfiles_dir = current_dir.joinpath(NVIM)

    install_directory(nvim_dotfiles_dir, NVIM_DIR)

    symlink_if_not_exists(current_dir.joinpath(".tmux.conf"), os.path.join(os.path.expanduser("~"), ".tmux.conf"))
    print("Complete!")

if __name__ == "__main__":
    main()
