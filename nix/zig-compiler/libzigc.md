## Cmake command in flake

Build:
```
mkdir build
cd build
<Cmake command>
ninja

stage3/bin/zig build -p stage4 -Denable-llvm -Dno-lib
```

## Edit

Search in lib/libc for occurrences of function and delete
Search in src/libs for occurrences of function and delete
Add myself to lib/c
Enable tests in test/libc.zig

Rerun
```
stage3/bin/zig build -p stage4 -Denable-llvm -Dno-lib
```

## Test

```
stage4/bin/zig build test-libc -Dlibc-test-path=../../libc-test -Dtest-filter=FILTER_HERE -fqemu -fwasmtime --summary line
```

## More commands

### Test Windows
```
stage4/bin/zig build test-modules -Dtest-target-filter=windows -Dtest-filter=FILTER_HERE --summary line
```

### Test std
```
stage4/bin/zig build test-std -Dtest-filter=FILTER_HERE -Dtest-target-filter=x86_64-linux-musl --summary line
```
