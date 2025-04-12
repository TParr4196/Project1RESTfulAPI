#!/bin/sh

status() {
    printf "\n=====================================================\n"
    printf "%s\n" "$1"
    printf -- "-----------------------------------------------------\n"
}

# Adapted from example in canvas

status 'GET all business should return success'
curl http://localhost:8086/business/

status 'GET business-by-id should return success'
curl http://localhost:8086/business/1

status 'GET business-by-id should return failure due to business not found'
curl http://localhost:8086/business/9999

status 'POST business should return failure due to bad request'
curl -X POST \
    -H 'Content-Type: application/json' \
    -d '{"stars": "1", "dollars": "1", "review": "Do not wish to return"}' \
    http://localhost:8086/business/

status 'POST business should return failure due to bad request'
curl -X POST \
    -H 'Content-Type: application/json' \
    -d '{}' \
    http://localhost:8086/business/

status 'POST business should return failure due to bad request'
curl -X POST \
    http://localhost:8086/business/


status 'POST business should return success'
curl -X POST \
    -H 'Content-Type: application/json' \
    -d '{"name": "example2 business", "address": "1232 example st", "city": "example2 city", "state": "example 2state", "zip": "12325", "phone": "1224567890", "category": "example2 category", "subcategory": "example2 subcategory", "website": "example2.com", "email": "example2@example.com"}' \
    http://localhost:8086/business/

status 'POST business should return success'
curl -X POST \
    -H 'Content-Type: application/json' \
    -d '{"name": "example2 business", "address": "1232 example st", "city": "example2 city", "state": "example 2state", "zip": "12325", "phone": "1224567890", "category": "example2 category", "subcategory": "example2 subcategory", "website": "example2.com", "email": "example2@example.com"}' \
    http://localhost:8086/business/

status 'DELETE business should return failure due to business not found'
curl -X DELETE \
    http://localhost:8086/business/9999

status 'DELETE business should return failure due to wrong endpoint'
curl -X DELETE \
    http://localhost:8086/business/

status 'DELETE business should return success'
curl -X DELETE \
    http://localhost:8086/business/1

status 'GET business after delete should return failure'
curl http://localhost:8086/business/1

status 'PUT business should return failure due to bad request'
curl -X PUT \
    -H 'Content-Type: application/json' \
    -d '{"stars": "1", "dollars": "1", "review": "Do not wish to return"}' \
    http://localhost:8086/business/1

status 'PUT business should return failure due to business not found'
curl -X PUT \
    -H 'Content-Type: application/json' \
    -d '{"name": "example2 business", "address": "1232 example st", "city": "example2 city", "state": "example 2state", "zip": "12325", "phone": "1224567890", "category": "example2 category", "subcategory": "example2 subcategory", "website": "example2.com", "email": "example2@example.com"}' \
    http://localhost:8086/business/203

status 'PUT business should return success'
curl -X PUT \
    -H 'Content-Type: application/json' \
    -d '{"name": "example2 business", "address": "1232 example st", "city": "example2 city", "state": "example 2state", "zip": "12325", "phone": "1224567890", "category": "example2 category", "subcategory": "example2 subcategory", "website": "example2.com", "email": "example2@example.com"}' \
    http://localhost:8086/business/1


#################################################################
# Reviews:


status 'GET all reviews should return success'
curl http://localhost:8086/review/

status 'GET review-by-id should return success'
curl http://localhost:8086/review/1

status 'GET review-by-id should return failure due to review not found'
curl http://localhost:8086/review/9999

status 'POST Review should return failure due to wrong endpoint'
curl -X POST \
    -H 'Content-Type: application/json' \
    -d '{"stars": "1", "dollars": "1", "written_review": "Do not wish to return"}' \
    http://localhost:8086/review/

status 'POST Review should return failure due to bad request'
curl -X POST \
    -H 'Content-Type: application/json' \
    -d '{"what the": "noice", "dollars": "1", "written_review": "Do not wish to return"}' \
    http://localhost:8086/review/1

status 'POST review should return failure due to wrong endpoint'
curl -X POST \
    -H 'Content-Type: application/json' \
    -d '{}' \
    http://localhost:8086/review/

status 'POST review should return failure due to bad request'
curl -X POST \
    http://localhost:8086/review/1

status 'POST Review should return failure due to stars and dollars not in range'
curl -X POST \
    -H 'Content-Type: application/json' \
    -d '{"stars": "-1", "dollars": "13", "written_review": "Do not wish to return"}' \
    http://localhost:8086/review/1

status 'POST Review should return failure due to review already made'
curl -X POST \
    -H 'Content-Type: application/json' \
    -d '{"stars": "1", "dollars": "1", "written_review": "Do not wish to return"}' \
    http://localhost:8086/review/1

status 'POST Review should return success'
curl -X POST \
    -H 'Content-Type: application/json' \
    -d '{"stars": "1", "dollars": "1", "written_review": "Do not wish to return"}' \
    http://localhost:8086/review/3

status 'PUT Review should return failure due to wrong endpoint'
curl -X PUT \
    -H 'Content-Type: application/json' \
    -d '{"stars": "1", "dollars": "1", "written_review": "Do not wish to return"}' \
    http://localhost:8086/review/

status 'PUT Review should return failure due to bad request'
curl -X PUT \
    -H 'Content-Type: application/json' \
    -d '{"what the": "noice", "dollars": "1", "written_review": "Do not wish to return"}' \
    http://localhost:8086/review/1

status 'PUT Review should return failure due to stars and dollars out of range'
curl -X PUT \
    -H 'Content-Type: application/json' \
    -d '{"stars": "-1", "dollars": "13", "written_review": "Do not wish to return", "business_id": 1}' \
    http://localhost:8086/review/1

status 'PUT Review should return failure due to business id not found'
curl -X PUT \
    -H 'Content-Type: application/json' \
    -d '{"stars": "1", "dollars": "1", "written_review": "Do not wish to return", "business_id": 322}' \
    http://localhost:8086/review/1

status 'PUT Review should return failure due to review id not found'
curl -X PUT \
    -H 'Content-Type: application/json' \
    -d '{"stars": "1", "dollars": "1", "written_review": "Do not wish to return", "business_id": 3}' \
    http://localhost:8086/review/5

status 'PUT Review should return success'
curl -X PUT \
    -H 'Content-Type: application/json' \
    -d '{"stars": "1", "dollars": "1", "written_review": "Do not wish to return", "business_id": 3}' \
    http://localhost:8086/review/1

status 'DELETE review should return failure'
curl -X DELETE \
    http://localhost:8086/review/9999

status 'DELETE review should return failure due to wrong endpoint'
curl -X DELETE \
    http://localhost:8086/review/

status 'DELETE review should return success'
curl -X DELETE \
    http://localhost:8086/review/1

status 'GET review after delete should return failure'
curl http://localhost:8086/review/1


#############################################
# Photos:

status 'GET all photos should return success'
curl http://localhost:8086/photo/

status 'GET photo-by-id should return success'
curl http://localhost:8086/photo/1

status 'GET photo-by-id should return failure'
curl http://localhost:8086/photo/9999

status 'POST photo should return failure due to wrong endpoint'
curl -X POST \
    -H 'Content-Type: application/json' \
    -d '{"stars": "1", "dollars": "1", "written_photo": "Do not wish to return"}' \
    http://localhost:8086/photo/

status 'POST photo should return failure due to bad request'
curl -X POST \
    -H 'Content-Type: application/json' \
    -d '{"what the": "noice", "dollars": "1", "written_photo": "Do not wish to return"}' \
    http://localhost:8086/photo/1

status 'POST photo should return failure due to bad request'
curl -X POST \
    -H 'Content-Type: application/json' \
    -d '{}' \
    http://localhost:8086/photo/

status 'POST photo should return failure due to bad request'
curl -X POST \
    http://localhost:8086/photo/1

status 'POST photo should return success'
curl -X POST \
    -H 'Content-Type: application/json' \
    -d '{"url": "1asdfasdf.com", "caption": "Do not wish to return"}' \
    http://localhost:8086/photo/1

status 'PUT photo should return failure due to wrong endpoint'
curl -X PUT \
    -H 'Content-Type: application/json' \
    -d '{"stars": "1", "dollars": "1", "written_photo": "Do not wish to return"}' \
    http://localhost:8086/photo/

status 'PUT photo should return failure due to bad request'
curl -X PUT \
    -H 'Content-Type: application/json' \
    -d '{"what the": "noice", "dollars": "1", "written_photo": "Do not wish to return"}' \
    http://localhost:8086/photo/1

status 'PUT photo should return failure due to business id not found'
curl -X PUT \
    -H 'Content-Type: application/json' \
    -d '{"url": "1asdfasdf.com", "caption": "Do not wish to return", "business_id": 322}' \
    http://localhost:8086/photo/1

status 'PUT photo should return success'
curl -X PUT \
    -H 'Content-Type: application/json' \
    -d '{"url": "1asdfasdf.com", "caption": "Do not wish to return", "business_id": 3}' \
    http://localhost:8086/photo/1

status 'DELETE photo should return failure'
curl -X DELETE \
    http://localhost:8086/photo/9999

status 'DELETE photo should return failure'
curl -X DELETE \
    http://localhost:8086/photo/

status 'DELETE photo should return success'
curl -X DELETE \
    http://localhost:8086/photo/1

status 'GET photo after delete should return failure'
curl http://localhost:8086/photo/1