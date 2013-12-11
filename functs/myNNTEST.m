function [net, g] = myNNTEST(nn, x, y)
    labels = nnpredict(nn, x);
    if nargin <3
        g = labels;
        net = nn;
        return
    else
        [~, expected] = max(y,[],2);
        bad = find(labels ~= expected);    
        er = numel(bad) / size(x, 1);
    end
end
