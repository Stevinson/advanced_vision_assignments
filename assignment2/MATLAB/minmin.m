%% Function that returns 

function arr = minmin(matrix)
    arr = zeros(size(matrix,1),1);
    m_v = max(max(matrix))*1.4;
    for i = 1:size(matrix,1)
<<<<<<< Updated upstream
        [mint, min_row] = min(matrix);
        [~, min_col] = min(mint);
        matrix(:,min_col) = m_v; %Dist can only be between 0 and 1.
        matrix(min_row(min_col),:) = m_v;
        arr(min_row(min_col)) = min_col;
=======
        [min_valforeach_col, row_loc] = min(matrix);
        [~, min_col] = min(min_valforeach_col);
        matrix(:,min_col) = m_v; % Sets column with min val in to m_v
        matrix
        matrix(row_loc(min_col),:) = m_v; % sets row with min val in to m_v
        matrix
         %matrix(row_loc,:) = m_v;
         %matrix
        arr(row_loc(min_col)) = min_col;
>>>>>>> Stashed changes
    end;
end
