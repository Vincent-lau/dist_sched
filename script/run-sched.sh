#!/bin/zsh


echo "===================deploying scheduler==================="

# compile the protobuf
protoc --go_out=. --go_opt=paths=source_relative \
    --go-grpc_out=. --go-grpc_opt=paths=source_relative \
    message/message.proto


go build -race -o ./bin/sched cmd/scheduler/main.go && \
docker build -t my-sched -f cmd/scheduler/Dockerfile . && \
docker tag my-sched cuso4/my-sched && \
docker push cuso4/my-sched && \
kubectl delete -f deploy/my-scheduler.yaml && \
kubectl apply -f deploy/my-scheduler.yaml

