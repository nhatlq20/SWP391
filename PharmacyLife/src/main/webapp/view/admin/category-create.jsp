<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Thêm danh mục</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
      
    </head>

    <body>
        <jsp:include page="/view/common/header.jsp" />
        <jsp:include page="/view/common/sidebar.jsp" />

        <div class="main-content">
            <h2 class="page-title"> <i class="fas fa-plus text-primary"></i>Thêm danh mục</h2>

            <div class="form-card">
                <form action="${pageContext.request.contextPath}/category" method="post">
                    <input type="hidden" name="action" value="insert" />

                    <div class="mb-4">
                        <label class="form-label" for="categoryCode">Mã mục</label>
                        <input type="text" id="categoryCode" name="categoryCode" class="form-control"
                            value="${nextCategoryCode}" readonly />
                    </div>

                    <div class="mb-4">
                        <label class="form-label" for="categoryName">Tên danh mục</label>
                        <input type="text" id="categoryName" name="categoryName" class="form-control"
                            placeholder="Nhập tên danh mục" required />
                    </div>

                    <div class="btn-row">
                        <button type="submit" class="btn btn-primary btn-pill"><i
                                class="fas fa-plus me-1"></i>Thêm</button>
                        <a href="${pageContext.request.contextPath}/category?action=list"
                            class="btn btn-secondary btn-pill">Hủy</a>
                    </div>
                </form>
            </div>
        </div>
    </body>

    </html>