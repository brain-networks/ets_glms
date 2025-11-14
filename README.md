# Duality of edge time series
In a few recent papers ([Zamani Esfahlani et al 2020](https://www.pnas.org/doi/abs/10.1073/pnas.2005531117) and [Faskowitz et al 2020](https://www.nature.com/articles/s41593-020-00719-y)), we proposed what we called ``edge time series'' as a way of obtaining framewise contributions to the correlation-based measures of functional connectivity (FC). The approach is simple. Suppose $\mathbf{z}_i = [z_i(1),\ldots,z_i(T)]$ is a z-scored time series from brain region $i$. The correlation between regions $i$ and $j$ is given as:

$$
r_{ij} = \frac{1}{T - 1} \sum_t [z_i(t) \cdot z_j(t)]
$$

The variable $r_{ij}$ is the standard bi-variate product-moment correlation and is often interpreted as a measure of functional connectivity. Our approach simply omits the summation, returning instead:

$$
r_{ij}(t) = z_i(t) \cdot z_j(t)
$$

The value of $r_{ij}(t)$ is the instantaneous co-fluctuation between the activity of regions $i$ and $j$. It is positive when the two regions are deviating in the same direction with respect to their means. It is large when the deviations are large; it is close to zero if one or both regions are close to their mean. Importantly, it tells us \emph{when}
