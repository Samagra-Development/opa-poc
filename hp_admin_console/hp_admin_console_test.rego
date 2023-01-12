package esamwad.backend.admin_console

import future.keywords.contains
import future.keywords.if
import future.keywords.in

# "Admin" role tests
test_admin_access_allowed_with_token if {
    allow with input as {"request":{"method":"GET","path":"/api/v5/assessment/invalidate","headers":{"authorization":opa.runtime().env.TEST_ADMIN_TOKEN}}}
}

test_admin_access_not_allowed_with_expired_token if {
    not allow with input as {"request":{"method":"GET","path":"/api/v5/assessment/invalidate","headers":{"authorization":opa.runtime().env.TEST_ADMIN_TOKEN_EXPIRED}}}
}

# "State Admin" role tests
test_state_admin_access_allowed_with_token if {
    allow with input as {"request":{"method":"GET","path":"/api/v5/assessment/invalidate","headers":{"authorization":opa.runtime().env.TEST_STATE_ADMIN_TOKEN}}}
}

test_state_admin_access_not_allowed_with_expired_token if {
    not allow with input as {"request":{"method":"GET","path":"/api/v5/assessment/invalidate","headers":{"authorization":opa.runtime().env.TEST_STATE_ADMIN_TOKEN_EXPIRED}}}
}

# "District Admin" role tests
test_district_admin_access_allowed_with_token if {
    allow with input as {"request":{"method":"GET","path":"/api/v5/assessment/invalidate","headers":{"authorization":opa.runtime().env.TEST_DISTRICT_ADMIN_TOKEN}}}
}

test_district_admin_access_not_allowed_with_expired_token if {
    not allow with input as {"request":{"method":"GET","path":"/api/v5/assessment/invalidate","headers":{"authorization":opa.runtime().env.TEST_DISTRICT_ADMIN_TOKEN_EXPIRED}}}
}

# "Block Admin" role tests
test_block_admin_access_allowed_with_token if {
    allow with input as {"request":{"method":"GET","path":"/api/v5/assessment/invalidate","headers":{"authorization":opa.runtime().env.TEST_BLOCK_ADMIN_TOKEN}}}
}

test_block_admin_access_not_allowed_with_expired_token if {
    not allow with input as {"request":{"method":"GET","path":"/api/v5/assessment/invalidate","headers":{"authorization":opa.runtime().env.TEST_BLOCK_ADMIN_TOKEN_EXPIRED}}}
}

# "School Admin" role tests
test_school_admin_access_allowed_with_token if {
    allow with input as {"request":{"method":"GET","path":"/api/v5/assessment/invalidate","headers":{"authorization":opa.runtime().env.TEST_SCHOOL_ADMIN_TOKEN}}}
}

test_school_admin_access_not_allowed_with_expired_token if {
    not allow with input as {"request":{"method":"GET","path":"/api/v5/assessment/invalidate","headers":{"authorization":opa.runtime().env.TEST_SCHOOL_ADMIN_TOKEN_EXPIRED}}}
}