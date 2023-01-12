package esamwad.backend.admin_console

import future.keywords.contains
import future.keywords.if
import future.keywords.in

default allow = false

allow if {
	is_valid_request
	is_admin
}
allow if {
	is_valid_request
    has_state_admin_access
}
allow if {
	is_valid_request
    has_district_admin_access
}
allow if {
	is_valid_request
    has_block_admin_access
}
allow if {
	is_valid_request
    has_school_admin_access
}

is_admin if result.current_role == "Admin"

has_state_admin_access if {
	result.current_role == "State Admin"
    
    # Find grants for roles
    some grant in role_grants

	grant.method == input.request.method
    grant.path == input.request.path
}

has_district_admin_access if {
	result.current_role == "District Admin"
    
    # Find grants for roles
    some grant in role_grants

	grant.method == input.request.method
    grant.path == input.request.path
}

has_block_admin_access if {
	result.current_role == "Block Admin"
    
    # Find grants for roles
    some grant in role_grants

	grant.method == input.request.method
    grant.path == input.request.path
}

has_school_admin_access if {
	result.current_role == "School Admin"
    
    # Find grants for roles
    some grant in role_grants

	grant.method == input.request.method
    grant.path == input.request.path
}

is_valid_request if {
	result.expiry > (time.now_ns() / 1000000000)	# if token is expired, we'll deny
    result.application_id == "77638847-db34-4331-b369-5768fdfededd"
}

role_grants contains grant if {
	# `role` assigned an element of the user_roles for this user...
	some grant in data.hp_admin_console.role_grants[result.current_role]
}

result = result {
   	# Bearer tokens are contained inside of the HTTP Authorization header. This rule
	# parses the header and extracts the Bearer token value. If no Bearer token is
	# provided, the `bearer_token` value is undefined.
	v := input.request.headers.authorization
	startswith(v, "Bearer ")
	bearer_token := substring(v, count("Bearer "), -1)

	# Verify the signature on the Bearer token. In this example the secret is
	# hardcoded into the policy however it could also be loaded via data or
	# an environment variable. Environment variables can be accessed using
	# the `opa.runtime()` built-in function.
	io.jwt.verify_rs256(bearer_token, opa.runtime().env.HP_ADMIN_CONSOLE_PUBLIC_KEY)

	# This statement invokes the built-in function `io.jwt.decode` passing the
	# parsed bearer_token as a parameter. The `io.jwt.decode` function returns an
	# array:
	#
	#	[header, payload, signature]
	#
	# In Rego, you can pattern match values using the `=` and `:=` operators. This
	# example pattern matches on the result to obtain the JWT payload.
	[_, payload, _] := io.jwt.decode(bearer_token)
    
    result:= {
		"current_role": payload["https://hasura.io/jwt/claims"]["x-hasura-default-role"],
        "expiry": payload["exp"],
        "application_id": payload["applicationId"]
    }
}
