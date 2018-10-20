%> @file Blasius.m
%> @brief The Blasius-formula
%=============================
%> @brief A function for calculating the Blasius formula
%>
%> Calculates the Blasius-formula as $\f \frac{0.316}{Re^{\frac{1}{4}}}
%>
%> @param Re The reynolds number
%> @return The lambda
function [lambda] = Blasius(Re)
    lambda = 0.316/(Re^(1/4))+0.004;
end
