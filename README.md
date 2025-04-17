
# lfs_custom_transfer

`lfs_custom_transfer` is a Python-based custom transfer agent for [Git Large File Storage (Git LFS)](https://git-lfs.github.com/). It enables Git LFS to interact with alternative storage backends, such as local directories or cloud storage services, by implementing the [Git LFS custom transfer protocol](https://github.com/git-lfs/git-lfs/blob/main/docs/custom-transfers.md).

> ⚠️ **This project is intended for testing and prototyping purposes only.** It provides a simple and transparent implementation of the Git LFS custom transfer interface to help developers experiment with custom storage solutions. It is not intended for production use, and has not been tested for performance, security, or fault tolerance in real-world environments.


## Features

- Implements Git LFS custom transfer protocol using Python.
- Supports both upload and download operations.
- Easily extensible to various storage backends (e.g., local filesystem, S3, GCS).
- Provides a foundation for building custom LFS transfer agents tailored to specific needs.

## Prerequisites

- Python 3.6 or higher.
- Git LFS installed and initialized in your repository.

## Installation

1. **Clone the Repository**

   ```bash
   git clone https://github.com/bwalsh/lfs_custom_transfer.git
   cd lfs_custom_transfer
   ```

2. **Make the Transfer Script Executable**

   See scripts/ for test scripts and examples.
 
   ```bash
   # ensure the transfer.py agent and test script are executable
   chmod +x scripts/*.*
   # add the scripts directory to your PATH
   export PATH=$PATH:$(pwd)/scripts
   ```

3. **Configure Git LFS to Use the Custom Transfer Agent**

   
   See [scripts/setup-lfs.sh](scripts/setup-lfs.sh)


   These settings tell Git LFS to use `transfer.py` as the custom transfer agent named `local`.

## Usage

1. Create a git repository, install lfs, add files and push to git
  See [create-repo-test](scripts/create-repo-test.sh)
2. Clone the repo
  See [clone-repo-test](scripts/clone-repo-test.sh)
   


## Configuration

The custom transfer agent reads from and writes to a designated storage directory. By default, this is set to `./lfs_storage`. You can change this by modifying the `STORAGE_DIR` variable in `transfer.py`:


```python
STORAGE_DIR = Path("/path/to/your/storage")
```


Ensure that the specified directory exists and is writable.

## Extending to Other Storage Backends

To adapt the transfer agent for other storage solutions like AWS S3 or Google Cloud Storage, you'll need to modify the `handle_upload` and `handle_download` functions in `transfer.py`. For example, integrating with AWS S3 would involve using the `boto3` library to upload and download objects.
># TODO Do this in GO ... 

## Troubleshooting

- Ensure that `transfer.py` is executable and accessible in your system's PATH.
- Verify that Git LFS is correctly configured to use the custom transfer agent.
- Check for any error messages output by the transfer agent during operations.

## License

This project is licensed under the MIT License.

## Acknowledgments

Inspired by the Git LFS custom transfer protocol documentation and community examples.

---

For more information on Git LFS custom transfer agents, refer to the [official documentation](https://github.com/git-lfs/git-lfs/blob/main/docs/custom-transfers.md).
