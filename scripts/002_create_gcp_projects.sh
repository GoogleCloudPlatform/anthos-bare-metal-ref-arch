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

title_no_wait "Create network project '${NETWORK_PROJECT_ID}'"
print_and_execute "gcloud projects create ${NETWORK_PROJECT_ID} --organization=${ORGANIZATION_ID} --folder=${FOLDER_ID}"
print_and_execute "gcloud beta billing projects link ${NETWORK_PROJECT_ID} --billing-account ${BILLING_ACCOUNT_ID}"

title_no_wait "Create platform project '${PLATFORM_PROJECT_ID}'"
print_and_execute "gcloud projects create ${PLATFORM_PROJECT_ID} --set-as-default --organization=${ORGANIZATION_ID} --folder=${FOLDER_ID}"
print_and_execute "gcloud beta billing projects link ${PLATFORM_PROJECT_ID} --billing-account ${BILLING_ACCOUNT_ID}"

title_no_wait "Create application project '${APP_PROJECT_ID}'"
print_and_execute "gcloud projects create ${APP_PROJECT_ID} --organization=${ORGANIZATION_ID} --folder=${FOLDER_ID}"
print_and_execute "gcloud beta billing projects link ${APP_PROJECT_ID} --billing-account ${BILLING_ACCOUNT_ID}"

check_local_error
total_runtime
exit ${local_error}
