# mokumoku-operator

```
$ cd example
$ stack exec -- mokumoku-operator 2020-07-04
owner: matsubara0507
connpass: 第39回Haskell-jpもくもく会 @ オンライン
```

## Requirement

## Usage

## Build

### Docker

```
$ stack --docker build -j 1 Cabal # if out of memory in docker
$ stack --docker --local-bin-path=./bin install
$ docker build -t matsubara0507/mokumoku-operator . --build-arg local_bin_path=./bin
```
