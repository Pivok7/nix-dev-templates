Setup:
```
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -B build
mv build/compile_commands.json .
```

Build:
```
cmake --build build
```

Run:
```
./build/main
```

Nixos:
```
nix run .
```
