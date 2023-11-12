function FE=findFrameForEvent(frame,event)
%paried arduino event to 2p frame ttl  
for t=1:length(event(:,1))
    a=find(frame>event(t,1));
    if ~isempty(a)
       FE(t,:)=a(1);
    else
        FE(t,:)=nan;
    end
end
end