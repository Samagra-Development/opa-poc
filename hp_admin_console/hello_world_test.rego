package hello.world

import future.keywords.if

test_allow_true if {
    allow with input as {"key": "world"}
}

test_allow_false if {
    not allow with input as {"key": "not world"}
}