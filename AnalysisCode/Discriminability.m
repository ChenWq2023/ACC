function d=Discriminability(Data)
%caculate d-prime for gonogo task
%Data=[Hit Miss CR FA]
 for i=1:size(Data,1)
     hitrate=Data(i,1)/(Data(i,1)+Data(i,2));
     FArate=Data(i,4)/(Data(i,3)+Data(i,4));
     if hitrate==1
         hitrate=1-1/(2*(Data(i,1)+Data(i,2)));
     end
      if hitrate==0
         hitrate=1/(2*(Data(i,1)+Data(i,2)));
     end
     if FArate==0
        FArate=1/(2*(Data(i,3)+Data(i,4)));
     end
     if FArate==1
        FArate=1-1/(2*(Data(i,3)+Data(i,4)));
     end
   d(i,:)=norminv(hitrate) - norminv(FArate);
 end
end
