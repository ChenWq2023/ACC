function out=cellidentify(Y1,Y2,method,p)
%out:1:yes;0:no;
%y1,y2: m*n mat,m:time,n:trial
%method:‘ranksum’;‘mean_mean';'mean_index1';'peak_index';;
%p:if method is ranksum,p is p-value;for other method,p is thesthod;
if method==1
    y1=mean(Y1,1); y2=mean(Y2,1);
    [t,~,stat]=ranksum(y1,y2);
    if t<p && stat.zval>0  
        out=1;
    else
        out=0;
    end
elseif method==2
     y1=mean(Y1,2); y2=mean(Y2,2);
    if (mean(y1)-mean(y2))>(p-1)*abs(mean(y2))
         out=1;
     else
         out=0;
    end
elseif method==3
    y1=mean(Y1,2); y2=mean(Y2,2);
    if  (mean(y1)-mean(y2))>p*abs(mean(y1)+mean(y2))
        out=1;
    else
        out=0;
    end
    elseif method==4
     y1=mean(Y1,2); y2=mean(Y2,2);
    if mean(y1)<=0 peak1=min(y1); else peak1=max(y1);end
    if mean(y2)<=0 peak2=min(y2); else peak2=max(y2);end
    if  (peak1-peak2)>p*abs(peak1+peak2)
        out=1;
    else
        out=0;
    end
end
end
