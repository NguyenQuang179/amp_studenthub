enum DashboardFilterOptions { all, working, archived }

enum JobDetailsTabOptions { proposal, detail, message, hired }

enum DataSource {
  SUCCESS,
  NO_CONTENT,
  BAD_REQUEST,
  FORBIDDEN,
  UNAUTORISED,
  NOT_FOUND,
  INTERNAL_SERVER_ERROR,
  CONNECT_TIMEOUT,
  CANCEL,
  RECIEVE_TIMEOUT,
  SEND_TIMEOUT,
  CACHE_ERROR,
  NO_INTERNET_CONNECTION,
  DEFAULT
}

const ProjectScopeToString = [
  '<1 month',
  '1-3 months',
  '3-6 months',
  '>6 months'
];
