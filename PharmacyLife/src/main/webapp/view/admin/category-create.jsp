<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Thêm danh mục</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            body {
                background: #f3f4f8;
            }

            .sidebar-wrapper {
                top: 115px !important;
                height: calc(100vh - 115px) !important;
                z-index: 100;
            }

            .main-content {
                margin-left: 275px;
                margin-top: 115px;
                padding: 20px;
            }

            .page-title {
                margin: 0 0 20px;
                font-size: 32px;
                font-weight: 700;
                color: #2a2d34;
            }

            .form-card {
                border: 0;
                border-radius: 16px;
                background: #fff;
                box-shadow: 0 1px 4px rgba(0, 0, 0, .08);
                padding: 28px;
            }

            .form-label {
                font-size: 18px;
                font-weight: 500;
                color: #2f3441;
                margin-bottom: 10px;
            }

            .form-control {
                height: 46px;
                font-size: 18px;
                border-radius: 10px;
            }

            .btn-row {
                display: flex;
                gap: 10px;
                margin-top: 20px;
            }

            .btn-pill {
                border-radius: 999px;
                font-size: 20px;
                padding: 6px 18px;
            }
        </style>
    </head>

    <body>
        <jsp:include page="/view/common/header.jsp" />
        <jsp:include page="/view/common/sidebar.jsp" />

        <div class="main-content">
            <h2 class="page-title"><i class="fas fa-plus me-2"></i>Thêm danh mục</h2>

            <div class="form-card">
                <form action="${pageContext.request.contextPath}/category" method="post">
                    <input type="hidden" name="action" value="insert" />

                    <div class="mb-4">
                        <label class="form-label" for="categoryCode">Mã mục</label>
                        <input type="text" id="categoryCode" name="categoryCode" class="form-control"
                            placeholder="Nhập mã mục" required />
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