#!/usr/bin/env bash

# Copyright 2021 Google LLC
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

if [ -d ${ACM_REPO_DIRECTORY} ]; then
    title_no_wait "Deleting the local ACM repository directory"
    print_and_execute "rm -rf ${ACM_REPO_DIRECTORY}"
fi

title_no_wait "Deleteting ACM CSR"
print_and_execute "gcloud source repos delete acm --project ${PLATFORM_PROJECT_ID} --quiet"

check_local_error
total_runtime
exit ${local_error}
