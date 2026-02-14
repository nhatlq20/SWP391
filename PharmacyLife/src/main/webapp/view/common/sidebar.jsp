<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value='${pageTitle != null ? pageTitle : "PharmacyLife"}'/></title>
    <link href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css" rel="stylesheet">
    <link href="<c:url value='/assets/css/header.css'/>" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
  </head>
  <body>
    <%@ include file="header.jsp" %>

    <div class="sidebar-wrapper">
      <main class="sidebar-content">
        <c:if test="${not empty content}">
          <jsp:include page="${content}"/>
        </c:if>
      </main>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
  </body>
  </html>

