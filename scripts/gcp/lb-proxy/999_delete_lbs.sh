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

LOG_FILE_PREFIX=gcp-lb-
source ${ABM_WORK_DIR}/scripts/helpers/include.sh

firewall_rule_name=allow-abm-cp-proxy-and-health-check 
title_no_wait "Deleting the firewall rule '${firewall_rule_name}'"
print_and_execute "gcloud compute firewall-rules delete --project=${NETWORK_PROJECT_ID} --quiet ${firewall_rule_name}"

for cluster_name in $(get_cluster_names); do
    load_cluster_config ${cluster_name}
    title_no_wait "Deleting the load balancers for '${cluster_name}'"

    title_no_wait "Deleting the ASM load balancer"

    firewall_rule_name=allow-${cluster_name}-asm-proxy-and-health-check 
    firewall_rule_tag=${cluster_name}-asm-lb
    bold_no_wait "Deleting the firewall rule '${firewall_rule_name}'"
    print_and_execute "gcloud compute firewall-rules delete --project=${NETWORK_PROJECT_ID} --quiet ${firewall_rule_name}"

    forwarding_rule_name=${cluster_name}-asm-80-forwarding-rule
    bold_no_wait "Deleting forwarding rule '${forwarding_rule_name}'"
    print_and_execute "gcloud compute forwarding-rules delete --project=${PLATFORM_PROJECT_ID} --quiet ${forwarding_rule_name} --global"

    forwarding_rule_name=${cluster_name}-asm-443-forwarding-rule
    bold_no_wait "Deleting forwarding rule '${forwarding_rule_name}'"
    print_and_execute "gcloud compute forwarding-rules delete --project=${PLATFORM_PROJECT_ID} --quiet ${forwarding_rule_name} --global"

    http_proxy_name=${cluster_name}-asm-http-proxy
    bold_no_wait "Deleting HTTP proxy '${http_proxy_name}'"
    print_and_execute "gcloud compute target-http-proxies delete --project=${PLATFORM_PROJECT_ID} --quiet ${http_proxy_name}"

    tcp_proxy_name=${cluster_name}-asm-tcp-proxy
    bold_no_wait "Deleting TCP proxy '${tcp_proxy_name}'"
    print_and_execute "gcloud compute target-tcp-proxies delete --project=${PLATFORM_PROJECT_ID} --quiet ${tcp_proxy_name}"

    url_map_name=${cluster_name}-asm-url-map
    bold_no_wait "Deleting URL map '${url_map_name}'"
    print_and_execute "gcloud compute url-maps delete --project=${PLATFORM_PROJECT_ID} --quiet  ${url_map_name}"

    backend_80_name=${cluster_name}-asm-80-lb
    bold_no_wait "Deleting backend '${backend_80_name}'"
    print_and_execute "gcloud compute backend-services delete --project=${PLATFORM_PROJECT_ID} --quiet ${backend_80_name} --global"

    backend_443_name=${cluster_name}-asm-443-lb
    bold_no_wait "Deleting backend '${backend_443_name}'"
    print_and_execute "gcloud compute backend-services delete --project=${PLATFORM_PROJECT_ID} --quiet ${backend_443_name} --global"

    neg_80_name=${cluster_name}-asm-80-neg
    bold_no_wait "Deleting network endpoint group '${neg_80_name}'"
    print_and_execute "gcloud compute network-endpoint-groups delete --project=${PLATFORM_PROJECT_ID} --quiet ${neg_80_name} --zone=${ZONE}"

    neg_443_name=${cluster_name}-asm-443-neg
    bold_no_wait "Deleting network endpoint group '${neg_443_name}'"
    print_and_execute "gcloud compute network-endpoint-groups delete --project=${PLATFORM_PROJECT_ID} --quiet ${neg_443_name} --zone=${ZONE}"

    address_name=${cluster_name}-asm-address
    bold_no_wait "Deleting address '${address_name}'"
    print_and_execute "gcloud compute addresses delete --project=${PLATFORM_PROJECT_ID} --quiet ${address_name} --global"

    title_no_wait "Deleting the ingress load balancer"

    firewall_rule_name=allow-${cluster_name}-ingress-proxy-and-health-check 
    bold_no_wait "Deleting the firewall rule '${firewall_rule_name}'"
    print_and_execute "gcloud compute firewall-rules delete --project=${NETWORK_PROJECT_ID} --quiet ${firewall_rule_name}"

    forwarding_rule_name=${cluster_name}-ingress-80-forwarding-rule
    bold_no_wait "Deleting forwarding rule '${forwarding_rule_name}'"
    print_and_execute "gcloud compute forwarding-rules delete --project=${PLATFORM_PROJECT_ID} --quiet ${forwarding_rule_name} --global"

    forwarding_rule_name=${cluster_name}-ingress-443-forwarding-rule
    bold_no_wait "Deleting forwarding rule '${forwarding_rule_name}'"
    print_and_execute "gcloud compute forwarding-rules delete --project=${PLATFORM_PROJECT_ID} --quiet ${forwarding_rule_name} --global"

    http_proxy_name=${cluster_name}-ingress-http-proxy
    bold_no_wait "Deleting HTTP proxy '${http_proxy_name}'"
    print_and_execute "gcloud compute target-http-proxies delete --project=${PLATFORM_PROJECT_ID} --quiet ${http_proxy_name}"

    tcp_proxy_name=${cluster_name}-ingress-tcp-proxy
    bold_no_wait "Deleting TCP proxy '${tcp_proxy_name}'"
    print_and_execute "gcloud compute target-tcp-proxies delete --project=${PLATFORM_PROJECT_ID} --quiet ${tcp_proxy_name}"

    url_map_name=${cluster_name}-ingress-url-map
    bold_no_wait "Deleting URL map '${url_map_name}'"
    print_and_execute "gcloud compute url-maps delete --project=${PLATFORM_PROJECT_ID} --quiet ${url_map_name}"

    backend_80_name=${cluster_name}-ingress-80-lb
    bold_no_wait "Deleting backend '${backend_80_name}'"
    print_and_execute "gcloud compute backend-services delete --project=${PLATFORM_PROJECT_ID} --quiet ${backend_80_name} --global"

    backend_443_name=${cluster_name}-ingress-443-lb
    bold_no_wait "Deleting backend '${backend_443_name}'"
    print_and_execute "gcloud compute backend-services delete --project=${PLATFORM_PROJECT_ID} --quiet ${backend_443_name} --global"

    neg_80_name=${cluster_name}-ingress-80-neg
    bold_no_wait "Deleting network endpoint group '${neg_80_name}'"
    print_and_execute "gcloud compute network-endpoint-groups delete --project=${PLATFORM_PROJECT_ID} --quiet ${neg_80_name} --zone=${ZONE}"

    neg_443_name=${cluster_name}-ingress-443-neg
    bold_no_wait "Deleting network endpoint group '${neg_443_name}'"
    print_and_execute "gcloud compute network-endpoint-groups delete --project=${PLATFORM_PROJECT_ID} --quiet ${neg_443_name} --zone=${ZONE}"

    address_name=${cluster_name}-ingress-address
    bold_no_wait "Deleting address '${address_name}'"
    print_and_execute "gcloud compute addresses delete --project=${PLATFORM_PROJECT_ID} --quiet ${address_name} --global"

    title_no_wait "Deleting the control plane load balancer"

    forwarding_rule_name=${cluster_name}-cp-forwarding-rule
    bold_no_wait "Deleting forwarding rule '${forwarding_rule_name}'"
    print_and_execute "gcloud compute forwarding-rules delete --project=${PLATFORM_PROJECT_ID} --quiet ${forwarding_rule_name} --global"

    tcp_proxy_name=${cluster_name}-cp-tcp-proxy
    bold_no_wait "Deleting TCP proxy '${tcp_proxy_name}'"
    print_and_execute "gcloud compute target-tcp-proxies delete --project=${PLATFORM_PROJECT_ID} --quiet ${tcp_proxy_name}"

    backend_name=${cluster_name}-cp-lb
    bold_no_wait "Deleting backend '${backend_name}'"
    print_and_execute "gcloud compute backend-services delete --project=${PLATFORM_PROJECT_ID} --quiet ${backend_name} --global"

    neg_name=${cluster_name}-cp-neg
    bold_no_wait "Deleting network endpoint group '${neg_name}'"
    print_and_execute "gcloud compute network-endpoint-groups delete --project=${PLATFORM_PROJECT_ID} --quiet ${neg_name} --zone=${ZONE}"

    address_name=${cluster_name}-cp-address
    bold_no_wait "Deleting address '${address_name}'"
    print_and_execute "gcloud compute addresses delete --project=${PLATFORM_PROJECT_ID} --quiet ${address_name} --global"
done

health_check_name=abm-asm-lb-health-check
bold_no_wait "Deleting TCP health check '${health_check_name}'"
print_and_execute "gcloud compute health-checks delete --project=${PLATFORM_PROJECT_ID} --quiet ${health_check_name}"

health_check_name=abm-ingress-lb-health-check
bold_no_wait "Deleting TCP health check '${health_check_name}'"
print_and_execute "gcloud compute health-checks delete --project=${PLATFORM_PROJECT_ID} --quiet ${health_check_name}"

health_check_name=abm-cp-lb-health-check
bold_no_wait "Deleting HTTPS health check '${health_check_name}'"
print_and_execute "gcloud compute health-checks delete --project=${PLATFORM_PROJECT_ID} --quiet ${health_check_name}"

check_local_error
total_runtime
exit ${local_error}
