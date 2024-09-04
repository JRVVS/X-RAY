X-RAY NMAP SCANNER

Version: 1.3
Creator: IK-JR Ijomah
Circa August 2024

Overview:
---------
X-RAY is a bash script for automated network scanning using Nmap and Dig. It supports scanning IP addresses or URLs to discover network services and vulnerabilities.

Features:
---------
- Flexible Scanning: IP or URL scanning.
- Single or Batch: Scan individual or multiple targets.
- Custom Output: Results and logs are organized by date and time.
- Progress Tracking: Real-time scan progress display.
- Error Handling: Manages unresolved URLs and invalid IPs.

Prerequisites:
--------------
- Nmap: Ensure Nmap is installed (`nmap` command).
- Dig: Required for URL scanning (fallbacks to IP scanning if missing).
- Bash Shell: Script runs in a bash environment.

Usage:
------
1. Run the script:
   $ ./xray_nmap_scanner.sh

2. Choose scan type:
   - Enter '1' for IP scanning.
   - Enter '2' for URL scanning.

3. Select scanning method:
   - For IP scanning: Single or multiple IPs.
   - For URL scanning: Single or multiple URLs.

4. Provide parameters:
   - Number of threads.
   - Output directory path.

5. View results:
   - Results are saved in the specified output directory.
   - Logs are stored in a `logs` subdirectory within the output directory.

Example:
--------
To scan a single IP with 10 threads and save results in `/tmp/results`:
$ ./xray_nmap_scanner.sh
# Follow the prompts:
# 1 (IPs)
# 1 (Single IP)
# 192.168.1.1
# 10 (threads)
# /tmp/results

Notes:
------
- Custom Wordlists: Not included.
- Log Files: Named based on scan date and time.
- Error Handling: Check logs for details on any issues.

Author:
-------
IK-JR Ijomah - Developed X-RAY V1.3 in August 2024 for enhanced network scanning.

