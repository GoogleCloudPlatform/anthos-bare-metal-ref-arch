#!/usr/bin/env bash

# Copyright 2022 Google LLC
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

${ABMRA_WORK_DIR}/scripts/gcp/994_unregister_cluster.sh && \
${ABMRA_WORK_DIR}/scripts/gcp/995_delete_cluster_instances.sh && \
${ABMRA_WORK_DIR}/scripts/gcp/lb-proxy/999_delete_lbs.sh && \
${ABMRA_WORK_DIR}/scripts/gcp/997_delete_cluster_configurations.sh && \
${ABMRA_WORK_DIR}/scripts/gcp/998_delete_gsas.sh && \
${ABMRA_WORK_DIR}/scripts/998_delete_acm_csr.sh && \
${ABMRA_WORK_DIR}/scripts/gcp/999_delete_admin_instance.sh
