% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/comments.R
\name{create_wrike_task_comment}
\alias{create_wrike_task_comment}
\title{Create comment on Wrike task}
\usage{
create_wrike_task_comment(task_id, comment_text)
}
\arguments{
\item{task_id}{Wrike task id associated with the task you want to create a comment on (ex:IEABOGRQKQAN3QOA)}

\item{comment_text}{Text of the comment you want added to Wrike}
}
\description{
Create a comment on a specified Wrike task
}
\examples{
create_wrike_task_comment("My Task Id", "comment")
create_wrike_task_comment("IEABOGRQKQAN3QOA", "hello there")
}
\keyword{}
