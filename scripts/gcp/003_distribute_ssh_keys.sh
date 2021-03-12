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

mkdir -p ${ABM_WORK_DIR}/keys
sudo cp ${DEPLOYMENT_USER_SSH_KEY}.pub ${ABM_WORK_DIR}/keys/

title_no_wait "Distributing ${DEPLOYMENT_USER} user's public SSH key" 
for cluster_name in $(get_cluster_names); do
    title_no_wait "${cluster_name}"
    load_cluster_config ${cluster_name}
    
    for cp in $(seq 1 $(get_number_of_control_plane_nodes)); do
        hostname="${cluster_name}-cp-${cp}"
        
        title_no_wait "${hostname} in ${ZONE}"
        print_and_execute "gcloud compute scp \
--project=${PLATFORM_PROJECT_ID} \
--zone=${ZONE} \
${ABM_WORK_DIR}/keys/id_rsa.pub ${hostname}:/tmp/"
        
        print_and_execute "gcloud compute ssh \
--command=\"sudo mv /tmp/id_rsa.pub ~${DEPLOYMENT_USER}/.ssh/authorized_keys && sudo chown ${DEPLOYMENT_USER}:${DEPLOYMENT_USER} ~${DEPLOYMENT_USER}/.ssh/authorized_keys\" \
--project=${PLATFORM_PROJECT_ID} \
--zone=${ZONE} \
${hostname}"
    done
    
    for worker in $(seq 1 $(get_number_of_worker_nodes)); do
        hostname="${cluster_name}-worker-${worker}"
        
        title_no_wait "${hostname} in ${ZONE}"
        print_and_execute "gcloud compute scp \
--project=${PLATFORM_PROJECT_ID} \
--zone=${ZONE} \
${ABM_WORK_DIR}/keys/id_rsa.pub ${hostname}:/tmp/"
        
        print_and_execute "gcloud compute ssh \
--command=\"sudo mv /tmp/id_rsa.pub ~${DEPLOYMENT_USER}/.ssh/authorized_keys && sudo chown ${DEPLOYMENT_USER}:${DEPLOYMENT_USER} ~${DEPLOYMENT_USER}/.ssh/authorized_keys\" \
--project=${PLATFORM_PROJECT_ID} \
--zone=${ZONE} \
${hostname}"
    done
done

check_local_error
total_runtime
exit ${local_error}
