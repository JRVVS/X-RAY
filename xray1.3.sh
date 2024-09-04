#!/bin/bash

# X-RAY NMAP SCANNER with Nmap and Dig
echo "                                           "
echo "###########################################"
echo "#                                         #"
echo "#           X-RAY V1.3                    #"
echo "#           Creator: IK Ijomah            #"
echo "#           CIRCA August 2024             #"
echo "#                                         #"
echo "###########################################"

# Check if nmap is installed
if ! command -v nmap &> /dev/null; then
    echo "nmap could not be found. Please install it before running this script."
    exit 1
fi

# User input for scanning choice
echo "Do you want to scan IPs or URLs?"
echo "1) IPs"
echo "2) URLs"
read -p "Enter your choice (1 or 2): " choice

# Check if the user selected URL scanning and verify if dig is installed
if [ "$choice" == "2" ]; then
    if ! command -v dig &> /dev/null; then
        echo "dig could not be found. Switching to IP scan option since dig is required for URL scanning."
        choice="1"
    fi
fi

# Function to perform the scan
perform_scan() {
    local target=$1
    local output_file=$2
    local log_file=$3

    # Perform the nmap scan and log the output
    sudo nmap -Pn -sS -sV -A -T4 \
    --script="address-info,afp-ls,afp-serverinfo,ajp-headers,asn-query,backorifice-info,banner,bitcoin-info,bittorrent-discovery,broadcast-dhcp-discover,broadcast-dhcp6-discover,broadcast-dns-service-discovery,broadcast-ms-sql-discover,broadcast-netbios-master-browser,broadcast-ping,broadcast-upnp-info,cassandra-info,cccam-version,cics-info,citrix-enum-apps,clamav-exec,clock-skew,coap-resources,couchdb-stats,creds-summary,cups-info,db2-das-info,dhcp-discover,dns-blacklist,dns-cache-snoop,dns-check-zone,dns-ip6-arpa-scan,dns-nsec-enum,dns-nsec3-enum,dns-recursion,dns-service-discovery,dns-zone-transfer,dns-brute,dns-srv-enum,dns-random-srcport,docker-version,epmd-info,finger,fingerprint-strings,firewalk,ftp-anon,ganglia-info,gkrellm-info,gopher-ls,gpsd-info,hadoop-datanode-info,hadoop-jobtracker-info,hadoop-namenode-info,hadoop-tasktracker-info,hbase-master-info,hbase-region-info,hddtemp-info,hnap-info,hostmap-bfk,hostmap-crtsh,hostmap-robtex,http-apache-server-status,http-auth,http-backup-finder,http-cakephp-version,http-date,http-default-accounts,http-errors,http-favicon,http-git,http-headers,http-hp-ilo-info,http-iis-short-name-brute,http-internal-ip-disclosure,http-ls,http-methods,http-passwd,http-php-version,http-qnap-nas-info,http-referer-checker,http-robots.txt,http-server-header,http-sitemap-generator,http-title,http-trace,http-vhosts,http-wordpress-users,iax2-version,icap-info,ike-version,imap-capabilities,informix-query,informix-tables,ip-forwarding,ip-geolocation-geoplugin,ip-geolocation-map-google,ipidseq,ipv6-node-info,irc-info,jdwp-info,jdwp-version,knx-gateway-info,ldap-rootdse,lltd-discovery,memcached-info,metasploit-info,mongodb-info,mqtt-subscribe,mrinfo,ms-sql-info,mtrace,mysql-info,mysql-query,mysql-users,nat-pmp-info,nbns-interfaces,nbstat,ncp-serverinfo,ndmp-version,nfs-showmount,nntp-ntlm-info,ntp-info,omron-info,oracle-tns-version,pcworx-info,pop3-capabilities,pop3-ntlm-info,port-states,pptp-version,quake3-info,rdp-enum-encryption,rdp-ntlm-info,riak-http-info,rpcinfo,s7-info,smb-enum-domains,smb-enum-groups,smb-enum-processes,smb-enum-services,smb-enum-sessions,smb-enum-shares,smb-enum-users,smb-os-discovery,smb-print-text,smb-protocols,smb-security-mode,smb-server-stats,smb-system-info,smb2-capabilities,smb2-security-mode,smtp-commands,smtp-enum-users,smtp-open-relay,snmp-info,snmp-interfaces,snmp-sysdescr,snmp-win32-services,snmp-win32-shares,snmp-win32-software,snmp-win32-users,ssh-auth-methods,ssh-hostkey,ssh2-enum-algos,stun-info,targets-asn,targets-ipv6-map4to6,targets-xml,teamspeak2-version,telnet-encryption,telnet-ntlm-info,tftp-version,tls-alpn,traceroute-geolocation,uptime-agent-info,upnp-info,ventrilo-info,versant-info,voldemort-info,weblogic-t3-info,whois-domain,whois-ip,wsdd-discover,x11-access,xdmcp-discover,xmpp-info,http-vuln-cve2017-1001000,http-vuln-cve2017-5638,http-vuln-cve2017-5689,http-vuln-cve2017-8917,http-vuln-cve2013-7091,http-vuln-cve2013-0156,http-vuln-cve2011-3368,http-vuln-cve2011-3192,http-vuln-cve2010-2861,http-vuln-cve2010-0738,http-vuln-cve2009-3960,http-vuln-cve2006-3392,http-vuln-misfortune-cookie,smb-vuln-ms17-010,smb-vuln-ms08-067,smb-vuln-conficker,smb-vuln-cve-2017-7494,smb-vuln-webexec,smb-vuln-cve2009-3103,smb-vuln-ms06-025,smb-vuln-ms10-054,smb-vuln-ms10-061,ftp-vuln-cve2010-4221,ssl-ccs-injection,ssl-heartbleed,vuln" \
    --script-args=unsafe=1 \
    -oN "$output_file" "$target" | tee -a "$log_file"

    if [ $? -eq 0 ]; then
        echo "Scan completed for $target. Results saved in $output_file." | tee -a "$log_file"
    else
        echo "Scan failed for $target." | tee -a "$log_file"
    fi
}

# Function to resolve URL to IP using dig
resolve_url_to_ip() {
    local url=$1
    dig +short $url | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$'
}

# Function to sanitize URL for filename
sanitize_url() {
    echo $1 | sed 's|https\?://||' | sed 's|/|_|g'
}

# Function to display scan progress
display_progress() {
    local current=$1
    local total=$2
    local percent=$(( 100 * current / total ))
    echo -ne "Progress: $percent% ($current/$total) completed\r"
}

# Handle IP scanning
if [ "$choice" == "1" ]; then
    echo "Do you want to scan a single IP or multiple IPs?"
    echo "1) Single IP"
    echo "2) Multiple IPs"
    read -p "Enter your choice (1 or 2): " ip_choice

    if [ "$ip_choice" == "1" ]; then
        attempts=0
        while [ $attempts -lt 5 ]; do
            read -p "Enter the IP address: " single_ip

            # Validate single IP
            if [[ $single_ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]] && [[ ! $single_ip =~ 25[6-9]|2[6-9][0-9]|[3-9][0-9]{2} ]]; then
                break
            else
                echo "Invalid IP address format. Please try again."
            fi
            ((attempts++))
        done

        if [ $attempts -ge 5 ]; then
            echo "Maximum attempts reached. Exiting."
            exit 1
        fi

    elif [ "$ip_choice" == "2" ]; then
        attempts=0
        while [ $attempts -lt 5 ]; do
            read -p "Enter the path to the file containing IP addresses: " ip_file

            # Check if IP file exists
            if [ -f "$ip_file" ]; then
                break
            else
                echo "IP file not found. Please try again."
            fi
            ((attempts++))
        done

        if [ $attempts -ge 5 ]; then
            echo "Maximum attempts reached. Exiting."
            exit 1
        fi
    fi

# Handle URL scanning
elif [ "$choice" == "2" ]; then
    echo "Do you want to scan a single URL or multiple URLs?"
    echo "1) Single URL"
    echo "2) Multiple URLs"
    read -p "Enter your choice (1 or 2): " url_choice

    if [ "$url_choice" == "1" ]; then
        attempts=0
        while [ $attempts -lt 5 ]; do
            read -p "Enter the URL: " single_url

            # Resolve URL to IP
            resolved_ip=$(resolve_url_to_ip "$single_url")

            if [ -z "$resolved_ip" ]; then
                echo "Could not resolve the URL to an IP address. Please try again."
            else
                url_name=$(sanitize_url "$single_url")
                break
            fi
            ((attempts++))
        done

        if [ $attempts -ge 5 ]; then
            echo "Maximum attempts reached. Exiting."
            exit 1
        fi

    elif [ "$url_choice" == "2" ]; then
        attempts=0
        unresolved_urls_file=""
        while [ $attempts -lt 5 ]; do
            read -p "Enter the path to the file containing URLs: " url_file

            # Check if URL file exists
            if [ -f "$url_file" ]; then
                unresolved_urls_file="$output_dir/unresolved-urls.txt"
                : > "$unresolved_urls_file"  # Empty the unresolved URLs file
                break
            else
                echo "URL file not found. Please try again."
            fi
            ((attempts++))
        done

        if [ $attempts -ge 5 ]; then
            echo "Maximum attempts reached. Exiting."
            exit 1
        fi
    fi
fi

# Ask for the number of threads
read -p "Enter the number of threads to use: " threads

# Ask for the output directory
read -p "Enter the path for the output directory: " output_dir

# Create output and log directories if they don't exist
if [ ! -d "$output_dir" ]; then
    mkdir -p "$output_dir"
    echo "Created output directory: $output_dir"
fi
log_dir="$output_dir/logs"
if [ ! -d "$log_dir" ]; then
    mkdir -p "$log_dir"
    echo "Created log directory: $log_dir"
fi

# Log file based on current date-time
log_file="$log_dir/$(date +'%Y-%m-%d_%H-%M-%S')-log.txt"

# Execute the scan
if [ "$choice" == "1" ]; then
    if [ "$ip_choice" == "1" ]; then
        result_file="$output_dir/${single_ip// /_}-results.txt"
        perform_scan "$single_ip" "$result_file" "$log_file"
        display_progress 1 1
    elif [ "$ip_choice" == "2" ]; then
        total_ips=$(wc -l < "$ip_file")
        current_ip=0
        while read -r IP; do
            if [ -z "$IP" ]; then
                echo "Skipping empty IP entry." | tee -a "$log_file"
                continue
            fi

            # Validate IP
            if [[ $IP =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]] && [[ ! $IP =~ 25[6-9]|2[6-9][0-9]|[3-9][0-9]{2} ]]; then
                result_file="$output_dir/${IP// /_}-results.txt"
                perform_scan "$IP" "$result_file" "$log_file"
                ((current_ip++))
                display_progress $current_ip $total_ips
            else
                echo "Invalid IP address format: $IP. Skipping." | tee -a "$log_file"
            fi
        done < "$ip_file"
    fi
elif [ "$choice" == "2" ]; then
    if [ "$url_choice" == "1" ]; then
        result_file="$output_dir/${url_name}-results.txt"
        perform_scan "$resolved_ip" "$result_file" "$log_file"
        display_progress 1 1
    elif [ "$url_choice" == "2" ]; then
        total_urls=$(wc -l < "$url_file")
        current_url=0
        while read -r URL; do
            if [ -z "$URL" ]; then
                echo "Skipping empty URL entry." | tee -a "$log_file"
                continue
            fi

            resolved_ip=$(resolve_url_to_ip "$URL")

            if [ -z "$resolved_ip" ]; then
                echo "$URL could not be resolved." | tee -a "$unresolved_urls_file"
                echo "$URL" | tee -a "$log_file"
                continue
            fi

            url_name=$(sanitize_url "$URL")
            result_file="$output_dir/${url_name}-results.txt"
            perform_scan "$resolved_ip" "$result_file" "$log_file"
            ((current_url++))
            display_progress $current_url $total_urls
        done < "$url_file"
    fi
fi

echo -ne "\n"
echo "Scan process completed. Logs can be found in $log_file"
if [ -n "$unresolved_urls_file" ] && [ -s "$unresolved_urls_file" ]; then
    echo "Some URLs could not be resolved. Check $unresolved_urls_file for details."
fi
