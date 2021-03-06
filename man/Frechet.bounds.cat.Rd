% --- Source file:  ---
\name{Frechet.bounds.cat}
\alias{Frechet.bounds.cat}
\title{Frechet bounds of cells in a contingency table}

\description{
This function permits to derive the bounds for cell probabilities of the table Y vs. Z starting from the marginal tables (\bold{X} vs. Y), (\bold{X} vs. Z) and the joint distribution of the \bold{X} variables.
}

\usage{
Frechet.bounds.cat(tab.x, tab.xy, tab.xz, print.f="tables", align.margins = FALSE,
                            tol= 0.001, warn = TRUE) 
}

\arguments{

\item{tab.x}{
A \R table crossing the \bold{X} variables.  This table must be obtained by using the function \code{\link[stats]{xtabs}} or \code{\link[base]{table}},  e.g. \cr
\code{tab.x <- xtabs(~x1+x2+x3, data=data.all)}. \cr
When \code{tab.x = NULL} then only \code{tab.xy} and \code{tab.xz} must be supplied.
}

\item{tab.xy}{
A \R table of \bold{X} vs. Y variable.  This table must be obtained by using the function \code{\link[stats]{xtabs}} or \code{\link[base]{table}}, e.g. \cr
\code{table.xy <- xtabs(~x1+x2+x3+y, data=data.A)}.

A single categorical Y variable is allowed.  One or more categorical variables can be considered as \bold{X} variables (common variables).  Obviously, the same \bold{X} variables in \code{tab.x} must be available in \code{tab.xy}.  Usually, it is assumed that the joint distribution of the \bold{X} variables computed from \code{tab.xy} is equal to \code{tab.x} (a warning appears if any absolute difference is greater than \code{tol}). Note that when marginal distribution of  \bold{X} in \code{tab.xy} is not equal to that of \code{tab.x} it is possible to ask their alignment (see argument \code{align.margins}).

When \code{tab.x = NULL} then \code{tab.xy} should be a one--dimensional table providing the marginal distribution of the Y variable.
}

\item{tab.xz}{
A \R table of \bold{X} vs. Z variable.  This table must be obtained by using the function \code{\link[stats]{xtabs}} or \code{\link[base]{table}}, e.g. \cr
\code{tab.xz <- xtabs(~x1+x2+x3+z, data=data.B)}.

A single categorical Z variable is allowed.  One or more categorical variables can be considered as \bold{X} variables (common variables).  The same \bold{X} variables in \code{tab.x} must be available in \code{tab.xz}.  Usually, it is assumed that the joint distribution of the \bold{X} variables computed from \code{tab.xz} is equal to \code{tab.x} (a warning appears if any absolute difference is greater than \code{tol}). Note that when marginal distribution of  \bold{X} in \code{tab.xz} is not equal to that of \code{tab.x} it is possible to ask their alignment (see argument \code{align.margins}).

When \code{tab.x = NULL} then \code{tab.xz} should be a one--dimensional table providing the marginal distribution of the Z variable.

}

\item{print.f}{
A string: when \code{print.f="tables"} (default) all the cells' estimates will be saved as tables in a list.  On the contrary, if \code{print.f="data.frame"}, they will be saved as columns of a data.frame.
}

\item{align.margins}{
Logical (default \code{FALSE}). When when \code{TRUE} the distribution of \bold{X} variables in \code{tab.xy} is aligned with the distribution resulting from \code{tab.x}, without affecting the marginal distribution of Y. Similarly, the distribution of \bold{X} variables in \code{tab.xz} is aligned with the distribution resulting from \code{tab.x} without affecting the marginal distribution of Z. The alignment is performed by running IPF algorithm as implemented in the function \code{\link[mipfp]{Estimate}} in the package \pkg{mipfp}. Note that to avoid lack of convergence due to combinations of Xs encountered in one table but not in the other (statistical 0s), before running IPF a small constant (1e-06) is added to empty cells in \code{tab.xy} and \code{tab.xz}.
}

\item{tol}{
Tolerance used in comparing joint distributions as far as \bold{X} variables are considered (default \code{tol= 0.001}); estimation of cells bounds would require that distribution of \bold{X} variables computed from \code{tab.xy} and \code{tab.xz} should be approximately equal to that in \code{tab.x}, on contrary  incoherences in estimated cells' bounds could happen. In case of not-coherent marginal distributions it is suggested to get them aligned by setting \code{align.margins=TRUE}.
}

\item{warn}{
Logical, when \code{TRUE} (default) return warnings when marginal distributions of \bold{X} variables show differences grater than \code{tol}.
}

}

\details{
This function permits to compute the expected conditional Frechet bounds for the relative frequencies in the contingency table of Y vs. Z, starting from the distributions P(Y|X), P(Z|X) and P(X).  The expected conditional bounds for the relative frequencies \eqn{p_{j,k}}{p(y=j,z=k)} in the table Y vs. Z are:

\deqn{  p^{(low)}_{Y=j,Z=k} = \sum_{i}  p_{X=i}\max (0; p_{Y=j|X=i} + p_{Z=k|X=i} - 1 ) }{p(Y=j,Z=k) >= sum_i(p(X=i) * max(0; p(Y=j|X=i) + p(Z=k|X=i) - 1) )}

\deqn{ p^{(up)}_{Y=j,Z=k} = \sum_{i} p_{X=i} \min ( p_{Y=j|X=i};  p_{Z=k|X=i})}{p(Y=j,Z=k) <= sum_i(p(X=i) * min(p(Y=j|X=i),p(Z=k|X=i))) }


The relative frequencies \eqn{p_{X=i}=n_i/n}{p(X=i)=n_i/n} are computed from the frequencies in \code{tab.x}; \cr
the relative frequencies \eqn{p_{Y=j|X=i}=n_{ij}/n_{i+}}{p(Y=j|X=i)=n_ij/n_i.} are derived from \code{tab.xy}, \cr
finally, \eqn{p_{Z=k|X=i}=n_{ik}/n_{i+}}{p(Z=k|X=i)=n_ik/n_i.} are derived from \code{tab.xz}.

Estimation requires that all the starting tables share the same marginal distribution of the \bold{X} variables. 

This function returns also the unconditional bounds for the relative frequencies in the contingency table of Y vs. Z, i.e. computed also without considering the \bold{X} variables:

\deqn{ \max\{0; p_{Y=j} + p_{Z=k} - 1\} \leq p_{Y=j,Z=k} \leq \min \{ p_{Y=j}; p_{Z=k}\}}{max(0;p(Y=j)+p(Z=k)-1) <= p(Y=j,Z=k) <= min(p(Y=j);p(Z=k))}

These bounds represent the unique output when \code{tab.x = NULL}.

Finally, the contingency table of Y vs. Z estimated under the Conditional Independence Assumption (CIA) is obtained by considering:

\deqn{ p_{Y=j,Z=k} = p_{Y=j|X=i} \times p_{Z=k|X=i} \times p_{X=i}.}{p(Y=i,Z=k) = p(Y=j|X=i)*p(Z=k|X=i)*p(X=i)}

When \code{tab.x = NULL} then it is also provided the expected table under the assumption of independence between Y and Z:

\deqn{ p_{Y=j,Z=k} = p_{Y=j} \times p_{Z=k}.}{p(Y=i,Z=k) = p(Y=j)*p(Z=k)*}

The presence of too many cells with 0s in the input contingency tables is an indication of sparseness; this is an unappealing situation when estimating the cells' relative frequencies needed to derive the bounds; in such cases the corresponding results may be unreliable. A possible alternative way of working consists in estimating the required parameters by considering a pseudo-Bayes estimator (see \code{\link[StatMatch]{pBayes}}); in practice the input \code{tab.x}, \code{tab.xy} and \code{tab.xz} should be the ones provided by the \code{\link[StatMatch]{pBayes}} function.

}

\value{
When \code{print.f="tables"} (default) a list with the following components:

\item{low.u}{
The estimated lower bounds for the relative frequencies in the table Y vs. Z without conditioning on the \bold{X} variables.
}

\item{up.u}{
The estimated upper bounds for the relative frequencies in the table Y vs. Z without conditioning on the \bold{X} variables.
}

\item{CIA}{
The estimated relative frequencies in the table Y vs. Z under the Conditional Independence Assumption (CIA).
}

\item{low.cx}{
The estimated lower bounds for the relative frequencies in the table Y vs. Z when conditioning on the \bold{X} variables.
}

\item{up.cx}{
The estimated upper bounds for the relative frequencies in the table Y vs. Z when conditioning on the \bold{X} variables.
}

\item{uncertainty}{
The uncertainty associated to input data, measured in terms of average width of uncertainty bounds with and without conditioning on the \bold{X} variables.
}


When \code{print.f="data.frame"} the output list contains just two components: 

\item{bounds}{
A data.frame whose columns reports the estimated uncertainty bounds.
}

\item{uncertainty}{
The uncertainty associated to input data, measured in terms of average width of uncertainty bounds with and without conditioning on the \bold{X} variables.
}

}

\references{

D'Orazio, M., Di Zio, M. and Scanu, M. (2006) ``Statistical Matching for Categorical Data: Displaying Uncertainty and Using Logical Constraints'', \emph{Journal of Official Statistics}, 22, pp. 137--157. 

D'Orazio, M., Di Zio, M. and Scanu, M. (2006). \emph{Statistical Matching: Theory and Practice.} Wiley, Chichester.

}


\author{
 Marcello D'Orazio \email{mdo.statmatch@gmail.com} 
}

\seealso{ 
\code{\link[StatMatch]{Fbwidths.by.x}}, \code{\link[StatMatch]{harmonize.x}}
}

\examples{

data(quine, package="MASS") #loads quine from MASS
str(quine)

# split quine in two subsets
suppressWarnings(RNGversion("3.5.0"))
set.seed(7654)
lab.A <- sample(nrow(quine), 70, replace=TRUE)
quine.A <- quine[lab.A, 1:3]
quine.B <- quine[-lab.A, 2:4]

# compute the tables required by Frechet.bounds.cat()
freq.xA <- xtabs(~Sex+Age, data=quine.A)
freq.xB <- xtabs(~Sex+Age, data=quine.B)

freq.xy <- xtabs(~Sex+Age+Eth, data=quine.A)
freq.xz <- xtabs(~Sex+Age+Lrn, data=quine.B)

# apply Frechet.bounds.cat()
bounds.yz <- Frechet.bounds.cat(tab.x=freq.xA+freq.xB, tab.xy=freq.xy,
        tab.xz=freq.xz, print.f="data.frame")
bounds.yz

# harmonize distr. of Sex vs. Age during computations
# in Frechet.bounds.cat()

#compare marg. distribution of Xs in A and B vs. pooled estimate
comp.prop(p1=margin.table(freq.xy,c(1,2)), p2=freq.xA+freq.xB, 
          n1=nrow(quine.A), n2=nrow(quine.A)+nrow(quine.B), ref=TRUE)

comp.prop(p1=margin.table(freq.xz,c(1,2)), p2=freq.xA+freq.xB, 
          n1=nrow(quine.A), n2=nrow(quine.A)+nrow(quine.B), ref=TRUE)

bounds.yz <- Frechet.bounds.cat(tab.x=freq.xA+freq.xB, tab.xy=freq.xy,
        tab.xz=freq.xz, print.f="data.frame", align.margins=TRUE)
bounds.yz

}


\keyword{multivariate}