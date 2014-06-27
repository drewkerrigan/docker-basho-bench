#!/bin/sh

cd /opt/basho_bench

wd=$(pwd)
test_tag=$1 && shift

mkdir -p ${wd}/reports/${test_tag}/

cat >> ${wd}/reports/${test_tag}/index.html << _EOF_
<!doctype html>
<html>
<head>
<title>Basho Bench Test [${test_tag}]</title>

<style>
.center {
    margin-left: auto;
    margin-right: auto;
    width: 70%;
}

h1, h2, h3, p {
    margin-left: 36px;
}

}</style>

</head>

<body>
<div class="center">
<h1>Basho Bench Test [${test_tag}]</h1>
_EOF_

# Iterate over given configs
while test ${#} -gt 0
do

test_config=$1
shift

sed -i.bak "s/localhost/${RIAK_PORT_8098_TCP_ADDR}/" config/${test_config}
sed -i.bak "s/127.0.0.1/${RIAK_PORT_8098_TCP_ADDR}/" config/${test_config}

mkdir -p ${wd}/reports/${test_tag}/${test_config}/

# Run Test
./basho_bench config/${test_config}
make results

cp -R tests/current/* ${wd}/reports/${test_tag}/${test_config}/

cat >> ${wd}/reports/${test_tag}/index.html << _EOF_
<h2>Test (${test_tag}): ${test_config}</h2>

<h3>Summary</h3>
<p>
<a href="${test_config}/summary.csv">summary.csv</a> |
<a href="${test_config}/errors.csv">errors.csv</a> |
<a href="${test_config}/console.log">console.log</a> |
<a href="${test_config}/crash.log">crash.log</a> |
<a href="${test_config}/error.log">error.log</a> |
<a href="${test_config}/${test_config}">${test_config}</a>
</p>

<a href="${test_config}/summary.png"><img width=800 height=600 src="${test_config}/summary.png" /></a>
_EOF_

done


cat >> ${wd}/reports/${test_tag}/index.html << _EOF_
</div>
</body>

</html>
_EOF_

rm ${wd}/reports/current
ln -fs ${wd}/reports/${test_tag} ${wd}/reports/current

python -m SimpleHTTPServer 9999