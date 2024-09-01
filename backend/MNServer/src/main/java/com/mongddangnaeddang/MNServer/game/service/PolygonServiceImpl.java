package com.mongddangnaeddang.MNServer.game.service;

import org.locationtech.jts.algorithm.ConvexHull;
import org.locationtech.jts.geom.*;
import org.locationtech.jts.io.ParseException;
import org.locationtech.jts.io.WKTReader;
import org.locationtech.jts.io.WKTWriter;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class PolygonServiceImpl implements PolygonService{

    GeometryFactory geometryFactory = new GeometryFactory();

    @Override
    public Coordinate[] createConvexHull(List<List<Double>> coordinateList) {
        Coordinate[] coordinates = new Coordinate[coordinateList.size()];
        Point[] points = new Point[coordinateList.size()];
        for (int i = 0; i < coordinateList.size(); i++) {
            List<Double> point = coordinateList.get(i);
            coordinates[i] = new Coordinate(point.get(0), point.get(1));
            points[i] = geometryFactory.createPoint(coordinates[i]);
        }

        MultiPoint multiPoint = geometryFactory.createMultiPoint(points);
        ConvexHull convexHull = new ConvexHull(multiPoint.getCoordinates(), geometryFactory);
        Geometry hullGeometry = convexHull.getConvexHull();

        Coordinate[] convexHullCoordinates = hullGeometry.getCoordinates();
        Coordinate[] polygonCoordinates = new Coordinate[convexHullCoordinates.length + 1];
        System.arraycopy(convexHullCoordinates, 0, polygonCoordinates, 0, convexHullCoordinates.length);
        polygonCoordinates[convexHullCoordinates.length] = convexHullCoordinates[0]; // 첫 번째 좌표 추가
        return polygonCoordinates;
    }

    @Override
    public Polygon createPolygon(Coordinate[] coordinates) {
        return geometryFactory.createPolygon(coordinates);
    }

    @Override
    public LineString createLineString(Coordinate[] coordinates) {
        return geometryFactory.createLineString(coordinates);
    }

    @Override
    public Polygon polygonWKTToPolygon(String polygonWKT){
        WKTReader wktReader = new WKTReader(geometryFactory);
        Polygon polygon = null;
        try {
            polygon = (Polygon) wktReader.read(polygonWKT);
        } catch (ParseException e) {
            throw new RuntimeException(e);
        }
        return polygon;
    }

    @Override
    public String polygonToPolygonWKT(Polygon polygon) {
        return new WKTWriter().write(polygon);
    }

    @Override
    public Map<String, List<List<Double>>> polygonToPoints(Polygon polygon) {
        Map<String, List<List<Double>>> result = new HashMap<>();

        // 외부 경계
        List<List<Double>> outerBoundary = new ArrayList<>();
        Coordinate[] coordinates = polygon.getExteriorRing().getCoordinates();
        for (Coordinate coordinate : coordinates) {
            List<Double> point = new ArrayList<>();
            point.add(coordinate.getX());
            point.add(coordinate.getY());
            outerBoundary.add(point);
        }
        result.put("outerBoundary", outerBoundary);

        // 내부 구멍
        if (polygon.getNumInteriorRing() > 0) {
            for (int i = 0; i < polygon.getNumInteriorRing(); i++) {
                List<List<Double>> hole = new ArrayList<>();
                Coordinate[] holeCoordinates = polygon.getInteriorRingN(i).getCoordinates();
                for (Coordinate coordinate : holeCoordinates) {
                    List<Double> point = new ArrayList<>();
                    point.add(coordinate.getX());
                    point.add(coordinate.getY());
                    hole.add(point);
                }
                result.put("hole"+i, hole);
            }
        }
        return result;
    }

    @Override
    public Polygon pointsToPolygon(Map<String, Coordinate[]> points) {
        // 외부 경계 좌표 변환
        LinearRing shell = geometryFactory.createLinearRing(points.get("outerBoundary"));

        // 구멍 좌표 변환
        Map<String, Coordinate[]> holes = points.entrySet()
                .stream()
                .filter(entry -> entry.getKey().startsWith("hole"))
                .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue));

        LinearRing[] interiorRings = null;
        if(!holes.isEmpty()){
            interiorRings = new LinearRing[holes.size()];
            Set<String> keys = holes.keySet();
            int interiorIdx = 0;
            for(String key : keys){
                interiorRings[interiorIdx++] = geometryFactory.createLinearRing(holes.get(key));
            }
        }
        return geometryFactory.createPolygon(shell, interiorRings);
    }
}
