% --- Source file: rankNND_hotdeck.Rd ---
\name{rankNND.hotdeck}
\alias{rankNND.hotdeck}
\title{ Rank distance hot deck method.}

\description{
  This function implements rank  hot deck distance method.  For each recipient record the closest donors is chosen by considering the distance between the percentage points of the empirical cumulative distribution function.
}

\usage{
rankNND.hotdeck(data.rec, data.don, var.rec, var.don=var.rec, 
                 don.class=NULL,  weight.rec=NULL, weight.don=NULL,
                 constrained=FALSE, constr.alg="Hungarian",
                 keep.t=FALSE) 
}

\arguments{

\item{data.rec}{
  A numeric matrix or data frame that plays the role of \emph{recipient}.  This data frame must contain the variable \code{var.rec} to be used in computing the percentage points of the empirical cumulative distribution function and eventually the variables that identify the donation classes (see argument \code{don.class}) and the case weights (see argument \code{weight.rec}). 

Missing values (\code{NA}) are not allowed.
}

\item{data.don}{
   A matrix or data frame that plays the role of \emph{donor}.  This data frame must contain the variable \code{var.don} to be used in computing percentage points of the the empirical cumulative distribution function and eventually the variables that identify the donation classes (see argument \code{don.class}) and the case weights (see argument \code{weight.don}).  
}

\item{var.rec}{
A character vector with the name of the variable in \code{data.rec} that should be ranked. 
}

\item{var.don}{
A character vector with the name of the variable \code{data.don} that should be ranked.  If not specified, by default \code{var.don=var.rec}.
}

\item{don.class}{
A character vector with the names of the variables (columns in both the data frames) that identify donation classes.  In each donation class the computation of percentage points is carried out independently.  Then only distances between percentage points of the units in the same donation class are computed.  The case of empty donation classes should be avoided.  It would be preferable that the variables used to form donation classes are defined as \code{factor}.

When not specified (default), no donation classes are used.
}

\item{weight.rec}{
Eventual name of the variable in \code{data.rec} that provides the weights that should be used in computing the the empirical cumulative distribution function for \code{var.rec} (see Details).
}

\item{weight.don}{
Eventual name of the variable in \code{data.don} that provides the weights that should be used in computing the the empirical cumulative distribution function for \code{var.don} (see Details).
}

\item{constrained}{
Logical.  When \code{constrained=FALSE} (default) each record in \code{data.don} can be used as a donor more than once.  On the contrary, when \cr \code{constrained=TRUE} each record in \code{data.don} can be used as a donor only once.  In this case, the set of donors is selected by solving a transportation problem, in order to minimize the overall matching distance.  See description of the argument \code{constr.alg} for details.
}

\item{constr.alg}{
A string that has to be specified when \code{constrained=TRUE}.  Two choices are available: \dQuote{lpSolve} and \dQuote{Hungarian}.  In the first case, \code{constr.alg="lpSolve"}, the transportation problem is solved by means of the function \code{\link[lpSolve]{lp.transport}} available in the package \pkg{lpSolve}.  When \code{constr.alg="Hungarian"} (default) the transportation problem is solved using the Hungarian method, implemented in function \code{\link[clue]{solve_LSAP}} available in the package \pkg{clue}.  Note that \cr \code{constr.alg="Hungarian"} is faster and more efficient.
}

\item{keep.t}{
Logical, when donation classes are used by setting  \code{keep.t=TRUE} prints information on the donation classes being processed (by default \code{keep.t=FALSE}).
}

}
  
\details{
This function finds a donor record for each record in the recipient data set.  The chosen donor is the one at the closest distance in terms of empirical cumulative distribution (Singh et al., 1990).  In practice the distance is computed by considering the estimated empirical cumulative distribution for the reference variable (\code{var.rec} and \code{var.don}) in \code{data.rec} and \code{data.don}.  The empirical cumulative distribution function is estimated by:

\deqn{ \hat{F}(y) = \frac{1}{n} \sum_{i=1}^{n} I(y_i\leq y) }{F(y) = (1/n) sum_i I(y_i <= y)}

being \eqn{I()=1}{I()=1} if \eqn{y_i\leq y}{ y_i <= y} and 0 otherwise.

In presence of weights, the empirical cumulative distribution function is estimated by:

\deqn{ \hat{F}(y) =  \frac{\sum_{i=1}^{n} w_i I(y_i\leq y)}{\sum_{i=1}^{n} w_i} }{F(y) = (sum_i w_i*I(y_i <= y)) /(sum_i w_i)}

In the unconstrained case, when there are more donors at the same distance, one of them is chosen at random.

When the donation class are introduced, then the empirical cumulative distribution function is estimated independently in each donation classes and the search of a recipient is restricted to donors in the same donation class.

A donor can be chosen more than once. To avoid it set \code{constrained=TRUE}. In such a case a donor can be chosen just once and the selection of the donors is carried out by solving a transportation problem with the objective of minimizing the overall matching distance (sum of the distances recipient-donor).
} 


\value{

A \R list with the following components:

\item{mtc.ids}{
A matrix with the same number of rows of \code{data.rec} and two columns.  The first column contains the row names of the \code{data.rec} and the second column contains the row names of the corresponding donors selected from the \code{data.don}.  When the input matrices do not contain row names, then a numeric matrix with the indexes of the rows is provided.
}
\item{dist.rd}{
A vector with the distances between each recipient unit and the corresponding donor. 
}

\item{noad}{
The number of available donors at the minimum distance for each recipient unit (only in unconstrained case)
}

\item{call}{
How the function has been called.
}

}

\references{

D'Orazio, M., Di Zio, M. and Scanu, M. (2006). \emph{Statistical Matching: Theory and Practice.} Wiley, Chichester.

Singh, A.C., Mantel, H., Kinack, M. and Rowe, G. (1993). \dQuote{Statistical matching: use of auxiliary information as an alternative to the conditional independence assumption}. \emph{Survey Methodology}, \bold{19}, 59--79.
}

\author{
 Marcello D'Orazio \email{mdo.statmatch@gmail.com} 
}

\seealso{ 
 
\code{\link[StatMatch]{NND.hotdeck}}
}

\examples{

data(samp.A, samp.B, package="StatMatch") #loads data sets

# samp.A plays the role of recipient
?samp.A

# samp.B plays the role of donor
?samp.B


# rankNND.hotdeck()
# donation classes formed using "area5"
# ecdf conputed on "age"
# UNCONSTRAINED case
out.1 <- rankNND.hotdeck(data.rec=samp.A, data.don=samp.B, var.rec="age",
                         don.class="area5")
fused.1 <- create.fused(data.rec=samp.A, data.don=samp.B,
                        mtc.ids=out.1$mtc.ids, z.vars="labour5")
head(fused.1)

#  as before but ecdf estimated  using weights
# UNCONSTRAINED case
out.2 <- rankNND.hotdeck(data.rec=samp.A, data.don=samp.B, var.rec="age",
                         don.class="area5",
                         weight.rec="ww", weight.don="ww")
fused.2 <- create.fused(data.rec=samp.A, data.don=samp.B,
                        mtc.ids=out.2$mtc.ids, z.vars="labour5")
head(fused.2)

}

\keyword{nonparametric}