#! /usr/bin/env bats

# Variable SUT_IP should be set outside this script and should contain the IP
# address of the System Under Test.

# Tests
connection_string="--os-username admin --os-project-name admin --os-user-domain-id default --os-project-domain-id default --os-identity-api-version 3 --os-auth-url http://${SUT_IP}:5000 --os-password ADMIN_PASS"


@test 'List projects' {
  run bash -c "openstack project list ${connection_string} --format csv"
  echo "output: "$output
  echo "status: "$status
  [[ "${status}" -eq "0" ]]
  [[ "${output}" =~ ',"admin"' ]]
}


@test 'List endpoints' {
  run bash -c "openstack endpoint list ${connection_string} --format csv"
  echo "output: "$output
  echo "status: "$status
  [[ "${status}" -eq "0" ]]
  [[ "${output}" =~ '"admin","http://172.17.0.2:35357"' ]]
  [[ "${output}" =~ '"internal","http://172.17.0.2:5000"' ]]
  [[ "${output}" =~ '"public","http://172.17.0.2:5000"' ]]
}


@test 'Create a project' {
  run bash -c "openstack project create ${connection_string} --format value travis"
  echo "output: "$output
  echo "status: "$status
  [[ "${status}" -eq "0" ]]
  [[ "${output}" =~ 'travis' ]]
} 

@test 'Create a service' {
  run bash -c "openstack service create ${connection_string} --format value --name swiftTravis --description 'Travis Swift' swift"
  echo "output: "$output
  echo "status: "$status
  [[ "${status}" -eq "0" ]]
  [[ "${output}" =~ 'Travis Swift' ]]
  [[ "${output}" =~ 'swiftTravis' ]]
}

@test 'Create an endpoint' {
  run bash -c "openstack endpoint create ${connection_string} --format value swift public http://localhost:5000"
  echo "output: "$output
  echo "status: "$status
  [[ "${status}" -eq "0" ]]
  [[ "${output}" =~ 'public' ]]
  [[ "${output}" =~ 'swift' ]]
  [[ "${output}" =~ 'swiftTravis' ]]
  [[ "${output}" =~ 'http://localhost:5000' ]]
}

