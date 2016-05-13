function L = L_call_pobs(dataset_num,data,par_arr,pobs)
% Calclation of log likelihood used in the imperfect observation model of
% monkeypox

MAXSIZE = 12;
switch(dataset_num)
    case 4 %MPX - point source vs secondary transmission
        if par_arr(2) > 1e3
            L = -inf;
            return
        end

        l_mj = zeros(MAXSIZE,MAXSIZE);
        for jj = 1:MAXSIZE
            for mm = 1:jj
                ps_data = zeros(1,mm);
                ps_data(end) = 1;
                l_mj(mm,jj) = exp(pointsource(par_arr(1:2), ps_data) + mult_prim_chains(par_arr(3:4), [1 mm jj]));
            end
        end
        l_j = sum(l_mj,1);
        l_j_unobs = l_j.*(1-pobs).^(1:MAXSIZE);
        prob_unobs = sum(l_j_unobs);
        
        L = 0;
        for ii = 1:size(data.mpx_prim_csize,1)
            L = L + data.mpx_prim_csize(ii,1)*log( ...
                l_mj(data.mpx_prim_csize(ii,2),data.mpx_prim_csize(ii,3))* ...
                (1 - (1-pobs).^data.mpx_prim_csize(ii,3))/ (1 - prob_unobs) ...
            );
        end

        %Alternate approach call (only primary cases have pobs bias)
        %L = pointsource_pobs(par_arr(1:2),pobs,data.mpx_ps) + multiplesource_onetype(par_arr(3:4),data.mpx_all);
end
