classdef Merge < handle
    properties
        seq; % niches sequence
        now; % now index
        nexti; % next index
        BLOCK; % Block size
    end

    methods
        function Ind = Merge(AN, BLOCK)
        %% Constructor Function
            %% Parameter setting
                % Merge position
                pos = [];
                for i = 1:BLOCK:AN
                    pos = [pos, i];
                end
            
                % Merge order
                global order;
                order = [];
                tail = floor(AN/BLOCK);
                Order(1, tail);
                order = [1, order, tail];
            
            %% Merge    
                % Merge sequence
                Ind.seq=[];
                for i = order
                    Ind.seq = [Ind.seq, pos(i):pos(i)+BLOCK-1];
                end
            
                Ind.seq = [Ind.seq, Ind.seq(end)+1:AN];
                Ind.now = Ind.seq(1:BLOCK);
                Ind.nexti = 1 + BLOCK;
                Ind.BLOCK = BLOCK;
        end

        function NOW = next(Ind)
            if length(Ind.seq)-Ind.nexti < 2*Ind.BLOCK-1
                % last Merge block
                Ind.now = Ind.seq(Ind.nexti:end);
                Ind.nexti = 1;
            else
                Ind.now = Ind.seq(Ind.nexti:Ind.nexti+Ind.BLOCK-1);
                Ind.nexti = Ind.nexti + Ind.BLOCK;
            end
            NOW = Ind.now;
        end

    end


end

%% Merge Function
function Order(l, r)
    global order;
    m = ceil( (l + r)/2 );
    order = [order, m];
    if (m - l) > 1
        Order(l, m);
    end
    if (r - m) > 1 
        Order(m, r);
    end
end
