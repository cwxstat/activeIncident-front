package db

import (
	"context"
	"fmt"
	"time"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

type Mongodb struct {
	Conn       *mongo.Client
	Database   string
	Collection string
}

func (m *Mongodb) DatabaseCollection(database string, collection string) {
	m.Database = database
	m.Collection = collection
}

func (m *Mongodb) Disconnect(ctx context.Context) error {
	return m.Conn.Disconnect(ctx)
}

func (m *Mongodb) EntriesMinutesAgo(ctx context.Context, minutes int, opts *options.FindOptions) (*mongo.Cursor, error) {

	col := m.Conn.Database(m.Database).Collection(m.Collection)

	cur, err := col.Find(ctx,
		bson.D{{"date", bson.D{{"$gt", time.Now().Add(-time.Minute * time.Duration(minutes))}}}}, opts)
	if err != nil {
		return nil, fmt.Errorf("mongodb.Find failed: %+v", err)
	}

	return cur, nil

}

func (m *Mongodb) Entries(ctx context.Context) ([]interface{}, error) {
	ctx, cancel := context.WithTimeout(ctx, 10*time.Second)
	defer cancel()

	col := m.Conn.Database(m.Database).Collection(m.Collection)
	cur, err := col.Find(ctx, bson.D{}, &options.FindOptions{
		Sort: map[string]interface{}{"_id": -1},
	})
	if err != nil {
		return nil, fmt.Errorf("mongodb.Find failed: %+v", err)
	}
	defer cur.Close(ctx)

	var out []interface{}
	for cur.Next(ctx) {
		var v interface{}
		if err := cur.Decode(&v); err != nil {
			return nil, fmt.Errorf("decoding mongodb record failed: %+v", err)
		}
		out = append(out, v)
	}
	if err := cur.Err(); err != nil {
		return nil, fmt.Errorf("failed to iterate on mongodb cursor: %+v", err)
	}
	return out, nil
}

func (m *Mongodb) AddEntry(ctx context.Context, e interface{}) error {
	ctx, cancel := context.WithTimeout(ctx, time.Second*3)
	defer cancel()

	col := m.Conn.Database(m.Database).Collection(m.Collection)
	if _, err := col.InsertOne(ctx, e); err != nil {
		return fmt.Errorf("mongodb.InsertOne failed: %+v", err)
	}
	return nil
}

func (m *Mongodb) DeleteAll(ctx context.Context, message string) error {
	ctx, cancel := context.WithTimeout(ctx, time.Second*3)
	defer cancel()

	col := m.Conn.Database(m.Database).Collection(m.Collection)
	if _, err := col.DeleteMany(ctx, bson.M{"message": message}); err != nil {
		return fmt.Errorf("mongodb.DeleteOne failed: %+v", err)
	}

	return nil
}
