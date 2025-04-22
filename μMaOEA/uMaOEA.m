classdef uMaOEA < ALGORITHM
% <many> <real/integer/label/binary/permutation>
% BLOCK  --- 5 ---   Merge block

%--------------------------------------------------------------------------------------------------------
% If you find this code useful in your work, please cite the following paper "H. Peng*, Z. Luo, T. Fang, 
% Q. Zhang, "Micro many-objective evolutionary algorithm with knowledge transfer," IEEE Transactions on 
% Emerging Topics in Computational Intelligence, 2024, 9(1): 43-56. 
%--------------------------------------------------------------------------------------------------------

    methods
        function main(Algorithm, Problem)
        %% Parameter setting
            BLOCK = Algorithm.ParameterSet(5);

        %% Initialization
            % Weight initialization
            global W;
            [W, Problem.N] = UniformlyRandomlyPoint(Problem.N, Problem.M);

            % neighbourhood
            global B;
            B = pdist2(W,W);
            [~,B] = sort(B,2);
            B = B(:,1:BLOCK);

            % Population/Archive initialization
            % LHS
            piece = Problem.N;
            Init_Dec = UniformPoint(piece, Problem.D, 'Latin');
            Population = Problem.Evaluation(repmat(Problem.upper-Problem.lower, piece, 1).*Init_Dec + repmat(Problem.lower, piece, 1));
            Archive = Problem.Initialization();

            % Divide subregion：Merge Controller
            MC = Merge(Problem.N, BLOCK);
            global NOW;
            NOW = MC.now;

        %% Optimization
            while Algorithm.NotTerminated(Archive)
%               Update population:  Merge Controller 
%                                   Nominal Convergence
%                                   Adaptive PBI
                Population = DecEvl(Problem, Population);

                % Controller：Fuzzy control
                Archive = Fuzzy_controller(Problem, Archive, Population, Problem.FE/Problem.maxFE);

                % Shift to next niche
                NOW = MC.next();
            end
        end
    end
end
