#!/bin/bash

#N :N/A
#OUT:N/A

function fun_perf_list()
{
  :> ./data/log/pmu_event.txt
  mflag=0
  perf list | grep $1| awk -F'[ \t]+' '{print $2}' > ./data/log/pmu_event.txt
  msum=`cat ./data/log/pmu_event.txt | grep "hisi" | wc -l`
  cat $msum $mflag
  if [ `cat /proc/cmdline | grep "acpi=force" | wc -l` -ne 1 ];then
    mflag=0
    MESSAGE="Fail"
  else
    if [ $msum -le 0 ];then
      mflag=0
      MESSAGE="Fail"
    else 
      mflag=1
    fi
  fi

  if [ $mflag -eq 1 ];then
    rand=$(awk 'NR==2 {print $1}' ./data/log/pmu_event.txt)
    rand2=$(awk 'NR==16 {print $1}' ./data/log/pmu_event.txt)
    perf stat -a -e $rand -e $rand2 -I 200 sleep 10s
    MESSAGE="Pass"
  fi 
}

function hha_perf_acpi_test()
{
    Test_Case_Title="Support HHA PMU events"

    fun_perf_list hisi_hha
}

function main()
{
    test_case_function_run
}

main