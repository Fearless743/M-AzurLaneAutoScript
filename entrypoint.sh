#!/bin/bash

FIX_MXNET=${FIX_MXNET}
TEMPLATE_FILE="/app/AzurLaneAutoScript/config/deploy.yaml"

if [ ! -f "$TEMPLATE_FILE" ];then
    echo "Lost config file, start recovery"
    cp /app/config/* /app/AzurLaneAutoScript/config/
fi

ERROR=$( { python -m mxnet | sed s/Output/Useless/ > outfile; } 2>&1 )
if [[ ! $ERROR =~ "module" ]]; then
    echo "try to fix mxnet version"
    pip install --upgrade mxnet -i https://mirrors.aliyun.com/pypi/simple
fi

U2_INIT_FILE="/usr/local/lib/python3.7/site-packages/uiautomator2/init.py"
if [ -f "$U2_INIT_FILE" ]; then
    sed -i 's#https://tool.appetizer.io#https://gh-proxy.org/github.com#g' "$U2_INIT_FILE"
fi

# run alas
python -m uiautomator2 init && \
python /app/AzurLaneAutoScript/gui.py
