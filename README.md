# Drivestats Demo App for SPL\_UK User Group

### Introduction

This app is just a bit of fun to show some different ways of structuring searches in Splunk dashboards.

There's some dashboards for showing:

* A standard search using `stats` vs its `tstats` equivalent for metdata (source, sourcetype, etc...)
* Multiple Single Value visualisations using multiple searches vs using a single search
* The advantage of using an Accelerated Data Model `tstats` search
* How sometimes it can still be better to use multiple searches (!)

The idea is to use the app to help Splunk users understand different ways to get the most out of the platfrom.

**NOTE:** Don't use this on a Production server. It's just for fun and education. Consider this your one and only warning.

**NOTE:** The app is in _no way_ maintained. It was created as a one off. There will be no updates! 😉


### The Drivestats Data Set

This is based around the excellent dataset from [Backblaze](https://www.backblaze.com/) on all of their hard drives.

It's a free (to the best of my knowledge) dataset, with these stipulations if you use it:

* You cite Backblaze as the source if you use the data
* You accept that you are solely responsible for how you use the data
* You do not sell this data to anyone. It is free.

The main page for the data is here:
[Backblaze - Hard Drive Data and Stats](https://www.backblaze.com/b2/hard-drive-test-data.html)


### Directory Structure

```
.
├── appserver
│   └── static
│       ├── data_model_multi_tstats-1-150.png
│       ├── data_model_tstats-1-150.png
│       ├── multi_search_vs_single_search-1-150.png
│       ├── stats_vs_tstats-1-150.png
│       ├── tools_data_model_info-1-150.png
│       └── tools_index_info-1-150.png
├── bin
│   ├── bb_download.sh
│   └── README
├── default
│   ├── app.conf
│   ├── data
│   │   ├── models
│   │   │   └── drivestats_acc.json
│   │   └── ui
│   │       ├── nav
│   │       │   └── default.xml
│   │       └── views
│   │           ├── 1_stats_vs_tstats.xml
│   │           ├── 2_multi_search_vs_single_search.xml
│   │           ├── 3_data_model_tstats.xml
│   │           ├── 4_data_model_multi_tstats.xml
│   │           ├── overview.xml
│   │           ├── README
│   │           ├── tools_data_model_info.xml
│   │           ├── tools_index_info.xml
│   │           └── tools_job_info.xml
│   ├── datamodels.conf
│   ├── indexes.conf
│   ├── inputs.conf
│   ├── limits.conf
│   ├── props.conf
│   └── transforms.conf
├── metadata
│   └── default.meta
└── README.md
```

### Netdata

For those interested in some some realtime monitoring for Linux, I highly recommend looking at **Netdata**

The easiest way to install this is to use the one-line script, which can be found here: <https://docs.netdata.cloud/packaging/installer/#one-line-installation>

The syntax is:
```bash
bash <(curl -Ss https://my-netdata.io/kickstart.sh) --dont-wait --install /opt/netdata
```

The optional `--install` allows you to provide an alternate location.

This worked on a completely plain CentOS 7 installation without any issues.


### Nginx Configuration

Not really part of the Demo App, but I do tend to front all my cloud-hosted demo boxes with Nginx. Then this is configured as a reverse proxy to the things I want to demo. In this case, it was both **Splunk** and **Netdata**.

It means that you can still get to your demo when the location is restricting outbound TCP ports. _(Splunk's default is TCP/8000 and Netdata is TCP/19999)_

You could use something like `certbot` to install a free SSL Certificate from Let's Encrypt.

It's beyond the scope of this doc to explain all the steps, but Google is your friend. If you're runnng this on CentOS or RHEL, then you'll may need to disable SELinux for this to work easily.

More for my reference than anything else, this is the config a use with Nginx:

```text
#
# Use's LetsEncrypt:
#
# certbot certonly -n --standalone --agree-tos --preferred-challenges http -d drivestats.example.com -m letsencrypt@example.com --pre-hook "systemctl stop nginx" --post-hook "systemctl start nginx"
#
server {
    listen                        80;
    server_name                   drivestats.example.com;
    return 301                    https://$host$request_uri;
}

server {

    listen                         443 ssl http2 default_server;
    ssl                            on;
    server_name                    drivestats.example.com;
    ssl_certificate                /etc/letsencrypt/live/drivestats.example.com/fullchain.pem;
    ssl_certificate_key            /etc/letsencrypt/live/drivestats.example.com/privkey.pem;
    ssl_protocols                  TLSv1.2;
    ssl_ciphers                    ECDHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers      on;

    location / {
        proxy_pass                 http://127.0.0.1:8000;
    }

    location ~ /netdata/(?<ndpath>.*) {
        proxy_redirect              off;
        proxy_set_header            Host $host;

        proxy_set_header            X-Forwarded-Host $host;
        proxy_set_header            X-Forwarded-Server $host;
        proxy_set_header            X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_http_version          1.1;
        proxy_pass_request_headers  on;
        proxy_set_header            Connection "keep-alive";
        proxy_store off;
        proxy_pass http://127.0.0.1:19999/$ndpath$is_args$args;

        gzip on;
        gzip_proxied any;
        gzip_types *;
    }

}
```


### Contact

If you need to contact me, you can email me at: `drivestats_splunk_demo <at> tinyinput.com`


### License Stuff

        Drivestats Splunk App for the SPL_UK User Group
        Copyright (C) 2019 Graham Morley

        A full copy of the license can be found in the LICENSE.md file
        in the root of the app directory.

        This program is free software: you can redistribute it and/or modify
        it under the terms of the GNU General Public License as published by
        the Free Software Foundation, either version 3 of the License, or
        (at your option) any later version.

        This program is distributed in the hope that it will be useful,
        but WITHOUT ANY WARRANTY; without even the implied warranty of
        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
        GNU General Public License for more details.

        You should have received a copy of the GNU General Public License
        along with this program.  If not, see <https://www.gnu.org/licenses/>.
