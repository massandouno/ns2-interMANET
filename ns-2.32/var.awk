#!/usr/local/bin/gawk -f

{
  if(NR==1){
    max=$1;
    min=$1;
  }
  sum+=$1;
  sumsq+=($1^2);
  if($1>max){max=$1};
  if($1<min){min=$1};
}
END{
  mean=sum/NR;
  variance=(sumsq-((sum^2)/NR))/(NR-1);
  std=sqrt(variance);
  #printf("%0.10f %0.10f %0.10f %0.10f %0.10f\n", mean, max, min, variance, sqrt(variance));
  #mean, std, 95% confidence interval
  #printf("%0.10f %0.10f %0.10f %0.10f %0.10f\n", mean, max, min, variance, sqrt(variance));
  printf("%0.3f %0.3f\n", mean, 1.96*std/sqrt(NR));
}


