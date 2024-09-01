package com.mongddangnaeddang.MNServer.game.service;

import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.LineString;
import org.locationtech.jts.geom.Polygon;

import java.util.List;
import java.util.Map;

public interface PolygonService {
    public Coordinate[] createConvexHull(List<List<Double>> coordinateList);
    public Polygon createPolygon(Coordinate[] coordinates);
    public LineString createLineString(Coordinate[] coordinates);

    public Polygon polygonWKTToPolygon(String polygonWKT);
    public String polygonToPolygonWKT(Polygon polygon);
    public Map<String, List<List<Double>>> polygonToPoints(Polygon polygon);
    public Polygon pointsToPolygon(Map<String, Coordinate[]> points);
}
