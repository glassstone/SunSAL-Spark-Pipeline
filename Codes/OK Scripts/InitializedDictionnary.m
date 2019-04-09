function D = InitializedDictionnary(EMAP_im, indexes)
% Auteur : ZA3

for i=1:size(indexes,2) 
        if((i == 1))
            D = reshape(EMAP_im(indexes(1,i),indexes(2,i),:), size(EMAP_im(indexes(1,i),indexes(2,i),:),3), 1);
        else
            D = cat(2, D, reshape(EMAP_im(indexes(1,i),indexes(2,i),:), size(EMAP_im(indexes(1,i),indexes(2,i),:),3), 1));          
        end
    end
end