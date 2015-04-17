#!/usr/bin/env bats
# vi: se ft=sh:


@test "solr link exists" {
    run test -L /opt/solr
    [ $status -eq 0 ]
}

@test "activator link target" {
    run test -e /opt/solr
    [ $status -eq 0 ]
}
