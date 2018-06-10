#! /usr/bin/env bats

# Variable SUT_IP should be set outside this script and should contain the IP
# address of the System Under Test.

# Tests
#connection_string="--os-username admin --os-project-name admin --os-user-domain-id default --os-project-domain-id default --os-identity-api-version 3 --os-auth-url http://${SUT_IP}:5000 --os-password ADMIN_PASS"
connection_string="--os-cloud travis"

@test 'List projects' {
  run bash -c "docker exec -ti ${SUT_ID} openstack ${connection_string} project list --format csv"
  echo "output: "$output
  echo "status: "$status
  [[ "${status}" -eq "0" ]]
  [[ "${output}" =~ ',"admin"' ]]
}


@test 'List endpoints' {
  run bash -c "docker exec -ti ${SUT_ID} openstack ${connection_string} endpoint list --format csv"
  echo "output: "$output
  echo "status: "$status
  [[ "${status}" -eq "0" ]]
  [[ "${output}" =~ '"RegionOne","keystone","identity",True,"admin"' ]]
  [[ "${output}" =~ '"RegionOne","openio-swift","object-store",True,"admin"' ]]
  [[ "${output}" =~ '"RegionOne","openio-swift","object-store",True,"public"' ]]
}


@test 'Create a project' {
  run bash -c "docker exec -ti ${SUT_ID} openstack ${connection_string} project create --format value travis"
  echo "output: "$output
  echo "status: "$status
  [[ "${status}" -eq "0" ]]
  [[ "${output}" =~ 'travis' ]]
} 

@test 'Create a service' {
  run bash -c "docker exec -ti ${SUT_ID} openstack ${connection_string} service create --format value --name swiftTravis --description 'Travis Swift' swift"
  echo "output: "$output
  echo "status: "$status
  [[ "${status}" -eq "0" ]]
  [[ "${output}" =~ 'Travis Swift' ]]
  [[ "${output}" =~ 'swiftTravis' ]]
}

@test 'Create an endpoint' {
  run bash -c "docker exec -ti ${SUT_ID} openstack ${connection_string} endpoint create --format value swift public http://localhost:5000"
  echo "output: "$output
  echo "status: "$status
  [[ "${status}" -eq "0" ]]
  [[ "${output}" =~ 'public' ]]
  [[ "${output}" =~ 'swift' ]]
  [[ "${output}" =~ 'swiftTravis' ]]
  [[ "${output}" =~ 'http://localhost:5000' ]]
}

