The original scripts were intended to run independently, but it is preferred
to run the Eclipse launchers.

To compute the SHA sums, go to the archive folder and run:

```bash
do_compute_sha() {
  # $1 shasum program
  # $2.. options
  # ${!#} file

  file=${!#}
  sha_file="${file}.sha"
  "$@" >"${sha_file}"
  echo "SHA: $(cat ${sha_file})"
}

for f in *.zip *.gz 
do
  do_compute_sha shasum -a 256 -p ${f}
done
```
