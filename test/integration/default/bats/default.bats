#!/usr/bin/env bats
# vi: se ft=sh:

@test "solr link exists" {
    run test -L /opt/solr
    [ $status -eq 0 ]
}

@test "solr link target exists" {
    run test -e /opt/solr
    [ $status -eq 0 ]
}

@test "solr ZK_HOST is set" {
    run grep '^ZK_HOST="[^ ]\+"' /var/solr/solr.in.sh
    [ $status -eq 0 ]
}

@test "zookeeper link exists" {
    run test -L /opt/zookeeper
    [ $status -eq 0 ]
}

@test "zookeeper link target exists" {
    run test -e /opt/zookeeper
    [ $status -eq 0 ]
}

@test "At least 1 zookeeper nodes are configured" {
    num=`grep -E  "server.[0-9]+=" /opt/zookeeper/conf/zoo.cfg| wc -l`
    [ "$num" -ge "1" ]
}

@test "solr listens on port 8987" {
    run curl -k  http://localhost:8987
    [ $status -eq 0 ]
}

@test "zookeeper listens on port 2181" {
    run curl -k  http://localhost:2181
    [ $status -eq 52 ] #Empty response, but port open.
}
