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

LOG_FILE_PREFIX=gcp-
source ${ABM_WORK_DIR}/scripts/helpers/include.sh

title_no_wait "Reset CloudShell"

rm -rf ${ABM_WORK_DIR}/logs
rm -rf ${ABM_WORK_DIR}/tmp

sed -e "s|^source ${ABM_WORK_DIR}/scripts/vars.sh$||g" ~/.profile
rm -f ${ABM_WORK_DIR}/scripts/var.sh

rm -f ~.ssh/google_compute_known_hosts

check_local_error
total_runtime
exit ${local_error}
