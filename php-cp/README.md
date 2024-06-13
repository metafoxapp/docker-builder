## Tools

## Profiling tools
- [xdebug profiler](https://xdebug.org/docs/profiler)
- [macos qcachegrind](https://formulae.brew.sh/formula/qcachegrind)
- [locust](https://docs.locust.io/en/stable/what-is-locust.html) to run load test.
- [newrelic](https://newrelic.com/)
- linux command iotop, htop to trace

## Calculate memory per fpm process

```bash
# calculate average memory perprocess
ps --no-headers -o "rss,cmd" -C php-fpm | awk '{ sum+=$1 } END { printf ("%d%s\n", sum/NR/1024,"M") }'
```

## php-fpm child process calculator

https://spot13.com/pmcalculator/


## Use qcachegrind

![/images/qcachegrind.png](/images/qcachegrind.png)

## Use locust tools

# dockers
