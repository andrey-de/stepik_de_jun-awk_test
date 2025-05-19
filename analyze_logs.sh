#!/bin/bash

echo "Отчет о логе веб-сервера" >> report.txt
echo "========================" >> report.txt

echo "Общее количество запросов: $(awk 'END {print NR}' access.log)" >> report.txt

echo "Количество уникальных IP-адресов: $(awk '{uniqueip[$1]++} END {print length(uniqueip)}' access.log)" >> report.txt
echo "" >> report.txt
echo "Количество запросов по методам:" >> report.txt
awk '
/GET/    {get++}
/POST/   {post++}
/PUT/    {put++}
/DELETE/ {del++}
END {
  if (get)  printf "  %d GET\n", get
  if (post) printf "  %d POST\n", post
  if (put)  printf "  %d PUT\n", put
  if (del)  printf "  %d DELETE\n", del
}' access.log >> report.txt

echo "" >> report.txt

awk '
{
  if (match($0, /"(GET|POST|PUT|DELETE) [^ ]+/)) {
    req = substr($0, RSTART+1, RLENGTH-1)
    split(req, arr, " ")
    method = arr[1]
    url = arr[2]
    urls[url]++
  }
}
END {
  max = 0
  popular = ""
  for (u in urls) {
    if (urls[u] > max) {
      max = urls[u]
      popular = u
    }
  }
  if (max > 0)
    print "Самый популярный URL: " max " " popular
}
' access.log >> report.txt

echo "Отчет сохранен в файл report.txt"