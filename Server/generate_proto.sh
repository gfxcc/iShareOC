#! /bin/bash

protoc -I ./ --grpc_out=. --plugin=protoc-gen-grpc=`which grpc_cpp_plugin` ./iShare.proto
protoc -I ./ --cpp_out=. ./iShare.proto
protoc --objc_out=. --objcgrpc_out=. ./*.proto

echo Fils Generated Success!
