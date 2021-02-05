#!/usr/bin/env bash

# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

source ${ABM_WORK_DIR}/scripts/helpers/include.sh

title_no_wait "Clone the application repository"
print_and_execute "cd ${ABM_WORK_DIR}"
print_and_execute "git clone https://github.com/GoogleCloudPlatform/bank-of-anthos.git"
sed 's/value: "true"/value: "false"/' -i ${ABM_WORK_DIR}/bank-of-anthos/kubernetes-manifests/*.yaml

check_local_error
total_runtime
exit ${local_error}
