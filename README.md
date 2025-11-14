# Duality of edge time series
In a few recent papers ([Zamani Esfahlani et al 2020](https://www.pnas.org/doi/abs/10.1073/pnas.2005531117) and [Faskowitz et al 2020](https://www.nature.com/articles/s41593-020-00719-y)), we proposed what we called ``edge time series'' as a way of obtaining framewise contributions to the correlation-based measures of functional connectivity (FC). The approach is simple. Suppose $\mathbf{z}_i = [z_i(1),\ldots,z_i(T)]$ is a z-scored time series from brain region $i$. The correlation between regions $i$ and $j$ is given as:

$$
r_{ij} = \frac{1}{T - 1} \sum_t [z_i(t) \cdot z_j(t)]
$$

The variable $r_{ij}$ is the standard bi-variate product-moment correlation and is often interpreted as a measure of functional connectivity. Our approach simply omits the summation, returning instead:

$$
r_{ij}(t) = z_i(t) \cdot z_j(t)
$$

The value of $r_{ij}(t)$ is the instantaneous co-fluctuation between the activity of regions $i$ and $j$. It is positive when the two regions are deviating in the same direction with respect to their means. It is large when the deviations are large; it is close to zero if one or both regions are close to their mean. Importantly, it tells us when these co-fluctuations occur.

When we first proposed this measure, we only had these ideas in mind; instantaneous co-fluctuations were a convenient way of decomposing a correlation into its framewise contributions (so we could, in principle, filter our correlations by retaining only specific kinds of frames) and returning a measure of time-varying connectivity. What we overlooked was the fact that each edge time series, $\mathbf{r}_ij = [r_{ij}(1),\ldots,r_{ij}(T)]$
is defined exactly the same way we define an interaction in elementary statistics.

We felt that this was interesting (it put our ad hoc measure of co-fluctuation time series on stronger statistical ground), but also opened up our eyes to new possibile ways of using these time series. One possibility, and the one that we focus on in the accompanying preprint, is to fully embrace edge time series as an interaction term in a multi-linear model that also contains terms for activations of regions $i$ and $j$, and to use the complete model to explain some time-behavior. That is, suppose $\mathbf{y}$ is some behavioral time series, we want to fit regression coefficients $\beta_i$, $\beta_j$, and $\beta_{ij}$ in the following equation:

$$
\mathbf{y} = \mathbf{z}_i \cdot \beta_i + \mathbf{z}_j \cdot \beta_j + \mathbf{z}_{ij} \cdot \beta_{ij} + \varepsilon
$$
